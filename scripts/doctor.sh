#!/usr/bin/env bash
#
# Checks the health of the repository. CI calls this too.
#
#   ./scripts/doctor.sh          # full check
#   ./scripts/doctor.sh --ci     # without .env and local tool checks
#
# Exits 1 when a problem is found.

# shellcheck source=scripts/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

cd "$REPO_ROOT" || exit 1

CI_MODE=0
[ "${1:-}" = "--ci" ] && CI_MODE=1

problems=0
report_problem() { fail "$@"; problems=$((problems + 1)); }

# ---------------------------------------------------------------- 1. documentation links

info "$T_DR_LINKS"

# Markdown links — always checked.
# The `|| true` is required: grep returns 1 when it matches nothing, and under
# `set -e` that aborted the group before backtick_paths ran, leaving files
# without markdown links entirely unchecked.
md_links() {
  grep -ohE '\]\([^)]+\)' "$1" 2>/dev/null | sed -E 's/^\]\(//; s/\)$//' || true
}

# Backticked tokens — only those that look like repository paths, so that
# `feature/short-name` (a branch) or `package.json` (a generic file name) are
# not reported. They must start with a known top-level directory.
backtick_paths() {
  # SC2016: the single quotes are intentional — this is a literal regex, and
  # the backticks are the characters being matched, not command substitution.
  # shellcheck disable=SC2016
  grep -ohE '`[A-Za-z0-9._/-]+`' "$1" 2>/dev/null | tr -d '`' \
    | grep -E '^(docs|apps|services|packages|scripts|infrastructure|design|\.github)/|^(README\.md|AGENTS\.md|CLAUDE\.md|PROJECT_INDEX\.md|CHANGELOG\.md|CONTRIBUTING\.md|SECURITY\.md|Makefile|LICENSE|\.env\.example)$' \
    || true
}

broken=0
checked=0
while IFS= read -r md; do
  base="$(dirname "$md")"
  while IFS= read -r target; do
    [ -n "$target" ] || continue
    case "$target" in
      http*|mailto:*|'#'*|'') continue ;;
      *'*'*|*'...'*|*'<'*)   continue ;;   # globs and placeholders
    esac
    target="${target%%#*}"                 # strip the anchor
    [ -n "$target" ] || continue
    checked=$((checked + 1))
    if [ ! -e "$base/$target" ] && [ ! -e "$REPO_ROOT/$target" ]; then
      report_problem "$T_DR_LINK_BROKEN" "$(rel "$md")" "$target"
      broken=$((broken + 1))
    fi
  done < <( { md_links "$md"; backtick_paths "$md"; } )
done < <(find . -name '*.md' -not -path './node_modules/*' -not -path './.git/*' | sort)

[ "$broken" -eq 0 ] && ok "$T_DR_LINKS_OK" "$checked"

# ---------------------------------------------------------------- 2. env parity

echo
info "$T_DR_ENV"

env_keys() { grep -E '^[A-Za-z_][A-Za-z0-9_]*=' "$1" | cut -d= -f1 | sort -u; }

# Prints each line of a list indented, for readable problem reports.
indent_list() { while IFS= read -r l; do [ -n "$l" ] && printf '         %s\n' "$l"; done; }

if [ ! -f .env.example ]; then
  report_problem "$T_DR_ENV_NO_EXAMPLE"
elif [ "$CI_MODE" -eq 1 ] || [ ! -f .env ]; then
  n="$(env_keys .env.example | wc -l | tr -d ' ')"
  if [ "$CI_MODE" -eq 1 ]; then
    ok "$T_DR_ENV_CI" "$n"
  else
    warn "$T_DR_ENV_NOT_CREATED"
  fi
else
  missing="$(comm -23 <(env_keys .env.example) <(env_keys .env))"
  extra="$(comm -13 <(env_keys .env.example) <(env_keys .env))"
  if [ -n "$missing" ]; then
    report_problem "$T_DR_ENV_MISSING"
    printf '%s\n' "$missing" | indent_list
  fi
  if [ -n "$extra" ]; then
    warn "$T_DR_ENV_EXTRA"
    printf '%s\n' "$extra" | indent_list
  fi
  [ -z "$missing" ] && [ -z "$extra" ] && ok "$T_DR_ENV_OK"
fi

# ---------------------------------------------------------------- 3. secret hygiene

echo
info "$T_DR_SECRETS"

secret_issue=0

if [ -d .git ] && git ls-files --error-unmatch .env >/dev/null 2>&1; then
  report_problem "$T_DR_SECRET_TRACKED"
  secret_issue=1
fi

grep -qxF '.env' .gitignore 2>/dev/null || {
  report_problem "$T_DR_SECRET_GITIGNORE"
  secret_issue=1
}

# Catches a real secret accidentally left in .env.example. This is a tripwire
# for copy-paste mistakes, not a full scanner: real keys are long and random
# (no underscores, no spaces), so placeholders like `app_dev_password` or
# `replace_with_...` are ignored.
if [ -f .env.example ]; then
  while IFS= read -r line; do
    key="${line%%=*}"; val="${line#*=}"
    case "$key" in
      *SECRET*|*TOKEN*|*PASSWORD*|*KEY*|*DSN*) ;;
      *) continue ;;
    esac
    case "$val" in
      ''|replace*|change*|your*|example*|dev*|local*|test*|'<'*) continue ;;
      *_*|*' '*) continue ;;
    esac
    if [ "${#val}" -ge 24 ]; then
      report_problem "$T_DR_SECRET_REAL" "$key"
      secret_issue=1
    fi
  done < <(grep -E '^[A-Za-z_][A-Za-z0-9_]*=' .env.example)
fi

[ "$secret_issue" -eq 0 ] && ok "$T_DR_SECRET_OK"

# ---------------------------------------------------------------- 4. YAML files

echo
info "$T_DR_YAML"

yaml_parser=""
if python3 -c 'import yaml' >/dev/null 2>&1; then
  yaml_parser=python3
elif has uv; then
  yaml_parser=uv
elif has yq; then
  yaml_parser=yq
fi

parse_yaml() {
  case "$yaml_parser" in
    python3) python3 -c 'import sys,yaml; yaml.safe_load(open(sys.argv[1]))' "$1" ;;
    uv)      uv run --quiet --with pyyaml python -c 'import sys,yaml; yaml.safe_load(open(sys.argv[1]))' "$1" ;;
    yq)      yq eval '.' "$1" >/dev/null ;;
  esac
}

if [ -z "$yaml_parser" ]; then
  warn "$T_DR_YAML_NO_PARSER"
else
  yaml_bad=0
  yaml_n=0
  while IFS= read -r y; do
    yaml_n=$((yaml_n + 1))
    if ! parse_yaml "$y" 2>/dev/null; then
      report_problem "$T_DR_YAML_BAD" "$(rel "$y")"
      yaml_bad=$((yaml_bad + 1))
    fi
  done < <(find . \( -name '*.yml' -o -name '*.yaml' \) \
             -not -path './node_modules/*' -not -path './.venv/*' \
             -not -path '*/node_modules/*' -not -path '*/.venv/*' \
             -not -path './.git/*' | sort)
  [ "$yaml_bad" -eq 0 ] && ok "$T_DR_YAML_OK" "$yaml_n" "$yaml_parser"
fi

# ---------------------------------------------------------------- 5. scripts are executable

echo
info "$T_DR_SCRIPTS"
script_issue=0
for s in scripts/*.sh; do
  [ -f "$s" ] || continue
  [ -x "$s" ] || { report_problem "$T_DR_SCRIPT_NOT_EXEC" "$s" "$s"; script_issue=1; }
done
[ "$script_issue" -eq 0 ] && ok "$T_DR_SCRIPTS_OK"

# ---------------------------------------------------------------- 6. local tools

if [ "$CI_MODE" -eq 0 ]; then
  echo
  info "$T_DR_TOOLS"
  for tool in git docker make; do
    if has "$tool"; then ok '%s' "$tool"; else warn "$T_DIR_NOT_FOUND" "$tool"; fi
  done
  if has docker && docker compose version >/dev/null 2>&1; then
    ok 'docker compose'
  elif has docker; then
    warn "$T_DR_COMPOSE_MISSING"
  fi
fi

# ---------------------------------------------------------------- 7. detected stacks

echo
info "$T_DR_STACKS"
found=0
while IFS= read -r dir; do
  stack="$(detect_stack "$dir")"
  [ "$stack" = none ] && continue
  ok '%s → %s' "$(rel "$dir")" "$stack"
  found=$((found + 1))
done < <(list_units)
[ "$found" -eq 0 ] && skip "$T_DR_NO_STACKS"

# ---------------------------------------------------------------- result

echo
if [ "$problems" -gt 0 ]; then
  fail "$T_DR_PROBLEMS" "$problems"
  exit 1
fi
ok "$T_DR_ALL_OK"

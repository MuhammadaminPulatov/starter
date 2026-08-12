#!/usr/bin/env bash
#
# Turns the template into a real project. Run once.
#
#   ./scripts/init-project.sh              # interactive
#   ./scripts/init-project.sh --dry-run    # show what would change, touch nothing
#   ./scripts/init-project.sh --name my-app --keep web,api-node
#
# Every destructive step asks for confirmation first.

# shellcheck source=scripts/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

cd "$REPO_ROOT" || exit 1

DRY_RUN=0
PROJECT_NAME=""
KEEP=""
ASSUME_YES=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --name)    PROJECT_NAME="${2:-}"; shift 2 ;;
    --keep)    KEEP="${2:-}"; shift 2 ;;
    --yes|-y)  ASSUME_YES=1; shift ;;
    -h|--help)
      sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'
      exit 0 ;;
    *) die "$T_INIT_UNKNOWN_ARG" "$1" ;;
  esac
done

[ "$DRY_RUN" -eq 1 ] && warn "$T_INIT_DRY"

confirm() {
  [ "$ASSUME_YES" -eq 1 ] && return 0
  [ "$DRY_RUN" -eq 1 ] && return 0
  printf '%s?%s %s %s' "$C_YELLOW" "$C_RESET" "$1" "$T_CONFIRM_SUFFIX"
  read -r ans </dev/tty
  [ "$ans" = "y" ] || [ "$ans" = "Y" ] || [ "$ans" = "ha" ] || [ "$ans" = "да" ]
}

do_run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '%s  dry%s %s\n' "$C_DIM" "$C_RESET" "$*"
  else
    "$@"
  fi
}

# Hides the difference between BSD (macOS) and GNU (Linux) sed.
sed_inplace() {
  local expr="$1"; shift
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '%s  dry%s %s\n' "$C_DIM" "$C_RESET" "$(printf "$T_INIT_DRY_EDIT" "$*")"
    return
  fi
  if sed --version >/dev/null 2>&1; then
    sed -i -e "$expr" "$@"
  else
    sed -i '' -e "$expr" "$@"
  fi
}

# ---------------------------------------------------------------- 1. project name

echo
info "$T_INIT_STEP_NAME"

if [ -z "$PROJECT_NAME" ]; then
  if [ "$DRY_RUN" -eq 1 ] || [ "$ASSUME_YES" -eq 1 ]; then
    PROJECT_NAME="$(basename "$REPO_ROOT")"
    printf "$T_INIT_NAME_AUTO\n" "$PROJECT_NAME"
  else
    printf "$T_INIT_NAME_PROMPT" "$(basename "$REPO_ROOT")"
    read -r PROJECT_NAME </dev/tty
    PROJECT_NAME="${PROJECT_NAME:-$(basename "$REPO_ROOT")}"
  fi
fi

case "$PROJECT_NAME" in
  *[!a-zA-Z0-9_-]*) die "$T_INIT_NAME_INVALID" "$PROJECT_NAME" ;;
esac

for f in .env.example docker-compose.yml README.md README.uz.md README.ru.md PROJECT_INDEX.md; do
  [ -f "$f" ] || continue
  sed_inplace "s/^APP_NAME=project$/APP_NAME=$PROJECT_NAME/; \
               s/^COMPOSE_PROJECT_NAME=project$/COMPOSE_PROJECT_NAME=$PROJECT_NAME/; \
               s/COMPOSE_PROJECT_NAME:-project/COMPOSE_PROJECT_NAME:-$PROJECT_NAME/" "$f"
done
ok "$T_INIT_NAME_SET" "$PROJECT_NAME"

# ---------------------------------------------------------------- 2. choose stacks

echo
info "$T_INIT_STEP_STACKS"

ALL_UNITS="apps/web apps/mobile apps/bot services/api-node services/api-python services/worker"

keep_unit() {
  local unit="$1" short="${1##*/}"
  case ",$KEEP," in
    *",$short,"*|*",$unit,"*) return 0 ;;
  esac
  return 1
}

to_delete=""
for unit in $ALL_UNITS; do
  [ -d "$unit" ] || continue
  if [ -n "$KEEP" ]; then
    keep_unit "$unit" || to_delete="$to_delete $unit"
  elif [ "$DRY_RUN" -eq 1 ] || [ "$ASSUME_YES" -eq 1 ]; then
    :   # nothing is deleted in non-interactive mode without --keep
  else
    if confirm "$(printf "$T_INIT_KEEP_Q" "$unit")"; then :; else to_delete="$to_delete $unit"; fi
  fi
done

if [ -n "$to_delete" ]; then
  warn "$T_INIT_WILL_DELETE" "$to_delete"
  if confirm "$T_INIT_CONFIRM"; then
    for unit in $to_delete; do
      do_run rm -rf "$unit"
      ok "$T_INIT_DELETED" "$unit"
      # Drop the matching documentation table rows too, otherwise
      # `make doctor` reports links pointing at a deleted directory.
      for doc in README.md README.uz.md README.ru.md PROJECT_INDEX.md; do
        [ -f "$doc" ] || continue
        # ',' as the delimiter because the pattern itself contains '|' and '/'
        sed_inplace "\\,^|.*\`$unit\`,d" "$doc"
      done
    done
    ok "$T_INIT_DOCS_UPDATED"
  else
    to_delete=""
    skip "$T_INIT_NOTHING_DELETED"
  fi
else
  skip "$T_INIT_ALL_KEPT"
fi

# ---------------------------------------------------------------- 3. .env

echo
info "$T_INIT_STEP_ENV"

if [ -f .env ]; then
  skip "$T_SETUP_ENV_EXISTS"
else
  do_run cp .env.example .env
  if [ "$DRY_RUN" -eq 0 ]; then
    if has openssl; then
      secret="$(openssl rand -hex 32)"
      sed_inplace "s|^JWT_SECRET=.*|JWT_SECRET=$secret|" .env
      ok "$T_INIT_JWT_SET"
    else
      warn "$T_INIT_NO_OPENSSL"
    fi
    sed_inplace "s|^APP_NAME=.*|APP_NAME=$PROJECT_NAME|; s|^COMPOSE_PROJECT_NAME=.*|COMPOSE_PROJECT_NAME=$PROJECT_NAME|" .env
  fi
  ok "$T_INIT_ENV_CREATED"
  warn "$T_INIT_FILL_TOKENS"
fi

# ---------------------------------------------------------------- 4. git

echo
info "$T_INIT_STEP_GIT"

if [ -d .git ]; then
  skip "$T_INIT_GIT_EXISTS"
elif confirm "$T_INIT_GIT_Q"; then
  do_run git init -q
  do_run git add -A
  do_run git commit -q -m "chore: initial project structure from template"
  ok "$T_INIT_GIT_DONE"
else
  skip "$T_INIT_GIT_SKIP"
fi

# ---------------------------------------------------------------- 5. cleanup

echo
info "$T_INIT_STEP_CLEAN"

if confirm "$T_INIT_SELF_Q"; then
  do_run rm -f "$REPO_ROOT/scripts/init-project.sh"
  ok "$T_INIT_SELF_DONE"
  warn "$T_INIT_SELF_WARN"
else
  skip "$T_INIT_SELF_KEPT"
fi

# ---------------------------------------------------------------- done

echo
ok "$T_INIT_DONE" "$PROJECT_NAME"
echo
printf '%s\n' "$T_INIT_NEXT"
printf '%s\n' "$T_INIT_NEXT_1"
printf '%s\n' "$T_INIT_NEXT_2"
printf '%s\n' "$T_INIT_NEXT_3"
printf '%s\n' "$T_INIT_NEXT_4"

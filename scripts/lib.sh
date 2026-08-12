#!/usr/bin/env bash
# Shared helpers. Other scripts `source` this file.
#
# Language: set STARTER_LANG=en|uz|ru to force one, otherwise it is detected
# from the system locale and falls back to English.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export REPO_ROOT

# --- colours --------------------------------------------------------------

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  C_RESET=$'\033[0m'; C_RED=$'\033[31m'; C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'; C_BLUE=$'\033[34m'; C_DIM=$'\033[2m'
else
  C_RESET=''; C_RED=''; C_GREEN=''; C_YELLOW=''; C_BLUE=''; C_DIM=''
fi

# --- language -------------------------------------------------------------

if [ -z "${STARTER_LANG:-}" ]; then
  case "${LC_ALL:-${LC_MESSAGES:-${LANG:-}}}" in
    uz*|UZ*) STARTER_LANG=uz ;;
    ru*|RU*) STARTER_LANG=ru ;;
    *)       STARTER_LANG=en ;;
  esac
fi
[ -f "$REPO_ROOT/scripts/lang/$STARTER_LANG.sh" ] || STARTER_LANG=en
# shellcheck source=/dev/null
. "$REPO_ROOT/scripts/lang/$STARTER_LANG.sh"
export STARTER_LANG

# --- output ---------------------------------------------------------------
#
# Every printer takes a printf format string plus its arguments:
#
#     ok "$T_INIT_NAME_SET" "$PROJECT_NAME"
#
# Passing a plain string with no placeholders also works.

_fmt() { local f="$1"; shift; printf "$f" "$@"; }

info()  { printf '%s==>%s %s\n' "$C_BLUE"   "$C_RESET" "$(_fmt "$@")"; }
ok()    { printf '%s  ok%s %s\n' "$C_GREEN" "$C_RESET" "$(_fmt "$@")"; }
warn()  { printf '%s warn%s %s\n' "$C_YELLOW" "$C_RESET" "$(_fmt "$@")"; }
fail()  { printf '%s fail%s %s\n' "$C_RED"  "$C_RESET" "$(_fmt "$@")"; }
skip()  { printf '%s skip%s %s\n' "$C_DIM"  "$C_RESET" "$(_fmt "$@")"; }
die()   { fail "$@"; exit 1; }

has() { command -v "$1" >/dev/null 2>&1; }

# --- project layout -------------------------------------------------------

# Lists every top-level unit directory (apps/*, services/*, packages/*).
# One level deep only.
list_units() {
  local base
  for base in apps services packages; do
    [ -d "$REPO_ROOT/$base" ] || continue
    find "$REPO_ROOT/$base" -mindepth 1 -maxdepth 1 -type d | sort
  done
}

# Detects the stack of a directory from its manifest file.
detect_stack() {
  local dir="$1"
  if   [ -f "$dir/package.json" ];   then echo node
  elif [ -f "$dir/pyproject.toml" ]; then echo python
  elif [ -f "$dir/go.mod" ];         then echo go
  elif [ -f "$dir/Cargo.toml" ];     then echo rust
  elif [ -f "$dir/pubspec.yaml" ];   then echo dart
  else echo none
  fi
}

# Picks the Node package manager from the lockfile.
detect_node_pm() {
  local dir="$1"
  if   [ -f "$dir/pnpm-lock.yaml" ]; then echo pnpm
  elif [ -f "$dir/yarn.lock" ];      then echo yarn
  elif [ -f "$dir/bun.lockb" ] || [ -f "$dir/bun.lock" ]; then echo bun
  else echo npm
  fi
}

# True when package.json declares the given script (works without jq too).
node_has_script() {
  local dir="$1" script="$2"
  if has jq; then
    jq -e --arg s "$script" '.scripts[$s] // empty' "$dir/package.json" >/dev/null 2>&1
  else
    grep -qE "\"$script\"[[:space:]]*:" "$dir/package.json"
  fi
}

rel() { printf '%s' "${1#"$REPO_ROOT"/}"; }

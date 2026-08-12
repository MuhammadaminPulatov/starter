#!/usr/bin/env bash
# Umumiy yordamchi funksiyalar. Boshqa skriptlar shuni `source` qiladi.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export REPO_ROOT

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  C_RESET=$'\033[0m'; C_RED=$'\033[31m'; C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'; C_BLUE=$'\033[34m'; C_DIM=$'\033[2m'
else
  C_RESET=''; C_RED=''; C_GREEN=''; C_YELLOW=''; C_BLUE=''; C_DIM=''
fi

info()  { printf '%s==>%s %s\n' "$C_BLUE" "$C_RESET" "$*"; }
ok()    { printf '%s  ok%s %s\n' "$C_GREEN" "$C_RESET" "$*"; }
warn()  { printf '%s warn%s %s\n' "$C_YELLOW" "$C_RESET" "$*"; }
fail()  { printf '%s fail%s %s\n' "$C_RED" "$C_RESET" "$*"; }
skip()  { printf '%s skip%s %s\n' "$C_DIM" "$C_RESET" "$*"; }
die()   { fail "$*"; exit 1; }

has() { command -v "$1" >/dev/null 2>&1; }

# Loyiha ichidagi barcha "birlik" papkalarni sanaydi (apps/*, services/*, packages/*).
# Ichma-ich papkalar emas — faqat birinchi daraja.
list_units() {
  local base
  for base in apps services packages; do
    [ -d "$REPO_ROOT/$base" ] || continue
    find "$REPO_ROOT/$base" -mindepth 1 -maxdepth 1 -type d | sort
  done
}

# Papkadagi manifestga qarab stack turini aniqlaydi.
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

# Node uchun lockfaylga qarab package managerni tanlaydi.
detect_node_pm() {
  local dir="$1"
  if   [ -f "$dir/pnpm-lock.yaml" ]; then echo pnpm
  elif [ -f "$dir/yarn.lock" ];      then echo yarn
  elif [ -f "$dir/bun.lockb" ] || [ -f "$dir/bun.lock" ]; then echo bun
  else echo npm
  fi
}

# package.json ichida berilgan script bor-yo'qligini tekshiradi (jq siz ham ishlaydi).
node_has_script() {
  local dir="$1" script="$2"
  if has jq; then
    jq -e --arg s "$script" '.scripts[$s] // empty' "$dir/package.json" >/dev/null 2>&1
  else
    grep -qE "\"$script\"[[:space:]]*:" "$dir/package.json"
  fi
}

rel() { printf '%s' "${1#"$REPO_ROOT"/}"; }

#!/usr/bin/env bash
#
# Detects the stack of every app/service/package directory and runs a task.
#
#   ./scripts/run.sh lint|test|build|install [dir ...]
#   ./scripts/run.sh --stack node lint          # node directories only
#
# With no directory given it walks apps/*, services/* and packages/*.
# When nothing matches it exits 0 but says exactly how many directories were
# skipped — "nothing to do" is never reported as "success".
#
# `--stack` matters in CI: each job installs only its own toolchain, so the
# node job must not touch a python directory.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

STACK_FILTER=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --stack)
      STACK_FILTER="${2:-}"
      case "$STACK_FILTER" in
        node|python|go|rust|dart) ;;
        *) die "$T_RUN_BAD_STACK" "$STACK_FILTER" ;;
      esac
      shift 2
      ;;
    *) break ;;
  esac
done

TASK="${1:-}"
case "$TASK" in
  lint|test|build|install) shift ;;
  *) die "$T_RUN_USAGE" "$(basename "$0")" ;;
esac

ran=0
skipped=0
failed=0
declare -a failed_units=()

# ALLOW_EMPTY_EXIT — an exit code meaning "there was nothing to run".
# pytest returns 5 when it collects no tests; that is not a failure.
run_in() {
  local dir="$1" name; name="$(rel "$dir")"
  shift
  info '%s: %s' "$name" "$*"
  local code=0
  ( cd "$dir" && "$@" ) || code=$?
  if [ "$code" -eq 0 ]; then
    ok '%s' "$name"
    ran=$((ran + 1))
  elif [ -n "${ALLOW_EMPTY_EXIT:-}" ] && [ "$code" -eq "$ALLOW_EMPTY_EXIT" ]; then
    skip "$T_RUN_NOTHING_HERE" "$name"
    skipped=$((skipped + 1))
  else
    fail "$T_RUN_FAILED" "$name" "$*" "$code"
    failed=$((failed + 1))
    failed_units+=("$name")
  fi
}

handle_node() {
  local dir="$1" name; name="$(rel "$dir")"
  local pm; pm="$(detect_node_pm "$dir")"
  has "$pm" || { warn "$T_TOOL_MISSING" "$name" "$pm"; skipped=$((skipped + 1)); return; }

  if [ "$TASK" = install ]; then
    case "$pm" in
      npm)  run_in "$dir" npm install ;;
      pnpm) run_in "$dir" pnpm install ;;
      yarn) run_in "$dir" yarn install ;;
      bun)  run_in "$dir" bun install ;;
    esac
    return
  fi

  if ! node_has_script "$dir" "$TASK"; then
    skip "$T_RUN_NO_SCRIPT" "$name" "$TASK"
    skipped=$((skipped + 1))
    return
  fi

  case "$pm" in
    npm)  run_in "$dir" npm run "$TASK" ;;
    pnpm) run_in "$dir" pnpm run "$TASK" ;;
    yarn) run_in "$dir" yarn run "$TASK" ;;
    bun)  run_in "$dir" bun run "$TASK" ;;
  esac
}

handle_python() {
  local dir="$1" name; name="$(rel "$dir")"

  # `uv run --with X` provides a tool without adding it to the project's
  # dependencies, so ruff/pytest work even when pyproject.toml omits them.
  # Without uv we fall back to the tool on PATH, otherwise we skip.
  py_exec() {
    local t="$1"; shift
    if has uv; then
      run_in "$dir" uv run --with "$t" "$t" "$@"
    elif has "$t"; then
      run_in "$dir" "$t" "$@"
    else
      skip "$T_RUN_PY_TOOL_MISSING" "$name" "$t" "$t"
      skipped=$((skipped + 1))
    fi
  }

  case "$TASK" in
    install)
      if has uv; then run_in "$dir" uv sync
      elif has pip; then run_in "$dir" pip install -e '.[dev]'
      else warn "$T_RUN_PY_NO_INSTALLER" "$name"; skipped=$((skipped + 1)); fi
      ;;
    lint) py_exec ruff check . ;;
    test)
      ALLOW_EMPTY_EXIT=5    # pytest returns 5 when no tests are collected
      py_exec pytest
      unset ALLOW_EMPTY_EXIT
      ;;
    build)
      skip "$T_RUN_PY_NO_BUILD" "$name"
      skipped=$((skipped + 1))
      ;;
  esac
}

handle_go() {
  local dir="$1" name; name="$(rel "$dir")"
  has go || { warn "$T_TOOL_MISSING" "$name" go; skipped=$((skipped + 1)); return; }
  case "$TASK" in
    install) run_in "$dir" go mod download ;;
    lint)    run_in "$dir" go vet ./... ;;
    test)    run_in "$dir" go test ./... ;;
    build)   run_in "$dir" go build ./... ;;
  esac
}

handle_rust() {
  local dir="$1" name; name="$(rel "$dir")"
  has cargo || { warn "$T_TOOL_MISSING" "$name" cargo; skipped=$((skipped + 1)); return; }
  case "$TASK" in
    install) run_in "$dir" cargo fetch ;;
    lint)    run_in "$dir" cargo clippy -- -D warnings ;;
    test)    run_in "$dir" cargo test ;;
    build)   run_in "$dir" cargo build ;;
  esac
}

handle_dart() {
  local dir="$1" name; name="$(rel "$dir")"
  has flutter || { warn "$T_TOOL_MISSING" "$name" flutter; skipped=$((skipped + 1)); return; }
  case "$TASK" in
    install) run_in "$dir" flutter pub get ;;
    lint)    run_in "$dir" flutter analyze ;;
    test)    run_in "$dir" flutter test ;;
    build)   skip "$T_RUN_DART_NO_BUILD" "$name"; skipped=$((skipped + 1)) ;;
  esac
}

# --- main loop ------------------------------------------------------------

units=()
if [ "$#" -gt 0 ]; then
  units=("$@")
else
  # `mapfile` needs bash 4+; this while-read loop also works on macOS bash 3.2.
  while IFS= read -r line; do
    [ -n "$line" ] && units+=("$line")
  done < <(list_units)
fi

total=${#units[@]}
filtered=0

for dir in ${units[@]+"${units[@]}"}; do
  [ -d "$dir" ] || { warn "$T_DIR_NOT_FOUND" "$dir"; continue; }
  unit_stack="$(detect_stack "$dir")"

  # With --stack set, directories in other languages are not this job's work.
  if [ -n "$STACK_FILTER" ] && [ "$unit_stack" != "$STACK_FILTER" ]; then
    filtered=$((filtered + 1))
    continue
  fi

  case "$unit_stack" in
    node)   handle_node   "$dir" ;;
    python) handle_python "$dir" ;;
    go)     handle_go     "$dir" ;;
    rust)   handle_rust   "$dir" ;;
    dart)   handle_dart   "$dir" ;;
    none)
      skip "$T_RUN_NO_MANIFEST" "$(rel "$dir")"
      skipped=$((skipped + 1))
      ;;
  esac
done

echo
scope=""
[ -n "$STACK_FILTER" ] && scope="$(printf "$T_RUN_SCOPE" "$STACK_FILTER" "$filtered")"

if [ "$failed" -gt 0 ]; then
  fail "$T_RUN_SUM_FAIL" "$TASK" "$failed" "$ran" "$skipped" "$total" "$scope"
  for u in "${failed_units[@]}"; do printf '       - %s\n' "$u"; done
  exit 1
fi

if [ "$ran" -eq 0 ]; then
  warn "$T_RUN_SUM_EMPTY" "$TASK" "$skipped" "$total" "$scope"
  printf '%s\n' "$T_RUN_HINT_1"
  printf '%s\n' "$T_RUN_HINT_2"
else
  ok "$T_RUN_SUM_OK" "$TASK" "$ran" "$skipped" "$total" "$scope"
fi

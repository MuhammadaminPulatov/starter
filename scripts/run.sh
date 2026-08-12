#!/usr/bin/env bash
#
# Har bir app/service/package papkasini aniqlab, so'ralgan vazifani bajaradi.
#
#   ./scripts/run.sh lint|test|build|install [papka ...]
#   ./scripts/run.sh --stack node lint          # faqat node papkalari
#
# Papka ko'rsatilmasa — apps/*, services/*, packages/* bo'ylab yuradi.
# Hech narsa topilmasa exit 0 qaytaradi, lekin nechta papka o'tkazib
# yuborilganini aniq yozadi. "Ish yo'q" bilan "ish muvaffaqiyatli" aralashmaydi.
#
# `--stack` CI uchun muhim: har bir job faqat o'z tilining vositalarini
# o'rnatadi, shuning uchun node job'i python papkasiga tegmasligi kerak.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

STACK_FILTER=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --stack)
      STACK_FILTER="${2:-}"
      case "$STACK_FILTER" in
        node|python|go|rust|dart) ;;
        *) die "--stack qiymati: node|python|go|rust|dart (berilgan: '$STACK_FILTER')" ;;
      esac
      shift 2
      ;;
    *) break ;;
  esac
done

TASK="${1:-}"
case "$TASK" in
  lint|test|build|install) shift ;;
  *) die "ishlatilishi: $(basename "$0") [--stack NOM] lint|test|build|install [papka ...]" ;;
esac

ran=0
skipped=0
failed=0
declare -a failed_units=()

# ALLOW_EMPTY_EXIT — "bajarish uchun hech narsa yo'q" ma'nosini beruvchi exit kod.
# Masalan pytest test topmasa 5 qaytaradi; bu xato emas, o'tkazib yuborish.
run_in() {
  local dir="$1" name; name="$(rel "$dir")"
  shift
  info "$name: $*"
  local code=0
  ( cd "$dir" && "$@" ) || code=$?
  if [ "$code" -eq 0 ]; then
    ok "$name"
    ran=$((ran + 1))
  elif [ -n "${ALLOW_EMPTY_EXIT:-}" ] && [ "$code" -eq "$ALLOW_EMPTY_EXIT" ]; then
    skip "$name: bajarish uchun hech narsa topilmadi"
    skipped=$((skipped + 1))
  else
    fail "$name — '$*' xato bilan tugadi (exit $code)"
    failed=$((failed + 1))
    failed_units+=("$name")
  fi
}

handle_node() {
  local dir="$1" name; name="$(rel "$dir")"
  local pm; pm="$(detect_node_pm "$dir")"
  has "$pm" || { warn "$name: '$pm' o'rnatilmagan, o'tkazib yuborildi"; skipped=$((skipped + 1)); return; }

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
    skip "$name: package.json da '$TASK' scripti yo'q"
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

  # `uv run --with X` vositani loyiha bog'liqliklariga qo'shmasdan taqdim etadi,
  # shuning uchun ruff/pytest pyproject.toml da e'lon qilinmagan bo'lsa ham ishlaydi.
  # uv yo'q bo'lsa — PATH dagi vositaga qaytamiz, u ham yo'q bo'lsa o'tkazib yuboramiz.
  py_exec() {
    local t="$1"; shift
    if has uv; then
      run_in "$dir" uv run --with "$t" "$t" "$@"
    elif has "$t"; then
      run_in "$dir" "$t" "$@"
    else
      skip "$name: '$t' topilmadi (uv yoki $t o'rnating)"
      skipped=$((skipped + 1))
    fi
  }

  case "$TASK" in
    install)
      if has uv; then run_in "$dir" uv sync
      elif has pip; then run_in "$dir" pip install -e '.[dev]'
      else warn "$name: uv ham, pip ham topilmadi"; skipped=$((skipped + 1)); fi
      ;;
    lint) py_exec ruff check . ;;
    test)
      ALLOW_EMPTY_EXIT=5    # pytest test topmasa 5 qaytaradi
      py_exec pytest
      unset ALLOW_EMPTY_EXIT
      ;;
    build)
      skip "$name: python servisi build bosqichini talab qilmaydi"
      skipped=$((skipped + 1))
      ;;
  esac
}

handle_go() {
  local dir="$1" name; name="$(rel "$dir")"
  has go || { warn "$name: go o'rnatilmagan"; skipped=$((skipped + 1)); return; }
  case "$TASK" in
    install) run_in "$dir" go mod download ;;
    lint)    run_in "$dir" go vet ./... ;;
    test)    run_in "$dir" go test ./... ;;
    build)   run_in "$dir" go build ./... ;;
  esac
}

handle_rust() {
  local dir="$1" name; name="$(rel "$dir")"
  has cargo || { warn "$name: cargo o'rnatilmagan"; skipped=$((skipped + 1)); return; }
  case "$TASK" in
    install) run_in "$dir" cargo fetch ;;
    lint)    run_in "$dir" cargo clippy -- -D warnings ;;
    test)    run_in "$dir" cargo test ;;
    build)   run_in "$dir" cargo build ;;
  esac
}

handle_dart() {
  local dir="$1" name; name="$(rel "$dir")"
  has flutter || { warn "$name: flutter o'rnatilmagan"; skipped=$((skipped + 1)); return; }
  case "$TASK" in
    install) run_in "$dir" flutter pub get ;;
    lint)    run_in "$dir" flutter analyze ;;
    test)    run_in "$dir" flutter test ;;
    build)   skip "$name: build maqsadi platformaga bog'liq, qo'lda ishga tushiring"; skipped=$((skipped + 1)) ;;
  esac
}

# --- asosiy sikl ---

units=()
if [ "$#" -gt 0 ]; then
  units=("$@")
else
  # `mapfile` bash 4+ talab qiladi; macOS'dagi bash 3.2 uchun while-read ishlatiladi.
  while IFS= read -r line; do
    [ -n "$line" ] && units+=("$line")
  done < <(list_units)
fi

total=${#units[@]}

filtered=0

for dir in ${units[@]+"${units[@]}"}; do
  [ -d "$dir" ] || { warn "$dir topilmadi"; continue; }
  unit_stack="$(detect_stack "$dir")"

  # --stack berilgan bo'lsa, boshqa tildagi papkalar bu ishga taalluqli emas.
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
      skip "$(rel "$dir"): manifest fayli yo'q (package.json / pyproject.toml / go.mod)"
      skipped=$((skipped + 1))
      ;;
  esac
done

echo
scope=""
[ -n "$STACK_FILTER" ] && scope=" [--stack $STACK_FILTER: $filtered papka boshqa tilda]"

if [ "$failed" -gt 0 ]; then
  fail "$TASK: $failed xato, $ran muvaffaqiyatli, $skipped o'tkazib yuborildi ($total papkadan)$scope"
  for u in "${failed_units[@]}"; do printf '       - %s\n' "$u"; done
  exit 1
fi

if [ "$ran" -eq 0 ]; then
  warn "$TASK: bajarish uchun hech narsa topilmadi — $skipped papka o'tkazib yuborildi ($total dan)$scope"
  echo "     Bu xato emas: hali kod qo'shilmagan. Papkaga package.json yoki"
  echo "     pyproject.toml qo'shilgach, u avtomatik topiladi."
else
  ok "$TASK: $ran muvaffaqiyatli, $skipped o'tkazib yuborildi ($total papkadan)$scope"
fi

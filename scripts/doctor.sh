#!/usr/bin/env bash
#
# Repozitoriya sog'lig'ini tekshiradi. CI ham shuni chaqiradi.
#
#   ./scripts/doctor.sh          # to'liq tekshiruv
#   ./scripts/doctor.sh --ci     # .env va lokal vosita tekshiruvisiz
#
# Muammo topilsa exit 1 qaytaradi.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

cd "$REPO_ROOT"

CI_MODE=0
[ "${1:-}" = "--ci" ] && CI_MODE=1

problems=0
report_problem() { fail "$*"; problems=$((problems + 1)); }

# ---------------------------------------------------------------- 1. hujjat havolalari

info "Hujjatlardagi ichki havolalar"

# Markdown havolalari — har doim tekshiriladi.
# `|| true` majburiy: grep hech narsa topmasa 1 qaytaradi va `set -e` tufayli
# keyingi backtick_paths chaqiruvi bajarilmay qolardi (markdown havolasiz fayllar
# butunlay tekshirilmasdi).
md_links() {
  grep -ohE '\]\([^)]+\)' "$1" 2>/dev/null | sed -E 's/^\]\(//; s/\)$//' || true
}

# Backtick ichidagi tokenlar — faqat repozitoriya yo'liga o'xshaganlari.
# `feature/short-name` (branch nomi) yoki `package.json` (umumiy fayl nomi) kabi
# tokenlarni noto'g'ri belgilamaslik uchun ular ma'lum ildiz papkadan boshlanishi shart.
backtick_paths() {
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
      *'*'*|*'...'*|*'<'*)   continue ;;   # glob va placeholder
    esac
    target="${target%%#*}"                 # ankorni olib tashlash
    [ -n "$target" ] || continue
    checked=$((checked + 1))
    if [ ! -e "$base/$target" ] && [ ! -e "$REPO_ROOT/$target" ]; then
      report_problem "$(rel "$md") → '$target' mavjud emas"
      broken=$((broken + 1))
    fi
  done < <( { md_links "$md"; backtick_paths "$md"; } )
done < <(find . -name '*.md' -not -path './node_modules/*' -not -path './.git/*' | sort)

[ "$broken" -eq 0 ] && ok "$checked havola tekshirildi, sinig'i yo'q"

# ---------------------------------------------------------------- 2. env pariteti

echo
info "Environment o'zgaruvchilari"

env_keys() { grep -E '^[A-Za-z_][A-Za-z0-9_]*=' "$1" | cut -d= -f1 | sort -u; }

if [ ! -f .env.example ]; then
  report_problem ".env.example topilmadi"
elif [ "$CI_MODE" -eq 1 ] || [ ! -f .env ]; then
  n="$(env_keys .env.example | wc -l | tr -d ' ')"
  if [ "$CI_MODE" -eq 1 ]; then
    ok ".env.example da $n ta kalit (CI rejimida .env tekshirilmaydi)"
  else
    warn ".env hali yaratilmagan — 'make setup' bajaring"
  fi
else
  missing="$(comm -23 <(env_keys .env.example) <(env_keys .env))"
  extra="$(comm -13 <(env_keys .env.example) <(env_keys .env))"
  if [ -n "$missing" ]; then
    report_problem ".env da yetishmayotgan kalitlar:"
    echo "$missing" | sed 's/^/         /'
  fi
  if [ -n "$extra" ]; then
    warn ".env da bor, lekin .env.example da yo'q (hujjatlashtiring):"
    echo "$extra" | sed 's/^/         /'
  fi
  [ -z "$missing" ] && [ -z "$extra" ] && ok ".env va .env.example kalitlari mos"
fi

# ---------------------------------------------------------------- 3. secret gigienasi

echo
info "Secret gigienasi"

secret_issue=0

if [ -d .git ] && git ls-files --error-unmatch .env >/dev/null 2>&1; then
  report_problem ".env git kuzatuvida! Darhol olib tashlang: git rm --cached .env"
  secret_issue=1
fi

grep -qxF '.env' .gitignore 2>/dev/null || {
  report_problem ".gitignore ichida '.env' qatori yo'q"
  secret_issue=1
}

# .env.example ichida haqiqiy secret qolib ketmaganini tekshirish.
# Bu to'liq skaner emas — tasodifiy nusxa-joylashtirishni ushlaydigan tripwire.
# Mantiq: haqiqiy kalitlar uzun va tasodifiy bo'ladi (pastki chiziqsiz, bo'shliqsiz).
# `app_dev_password` yoki `replace_with_...` kabi placeholderlar o'tkazib yuboriladi.
if [ -f .env.example ]; then
  while IFS= read -r line; do
    key="${line%%=*}"; val="${line#*=}"
    case "$key" in
      *SECRET*|*TOKEN*|*PASSWORD*|*KEY*|*DSN*) ;;
      *) continue ;;
    esac
    case "$val" in
      ''|replace*|change*|your*|example*|dev*|local*|test*|'<'*) continue ;;
      *_*|*' '*) continue ;;                       # pastki chiziq/bo'shliq → placeholder
    esac
    if [ "${#val}" -ge 24 ]; then
      report_problem ".env.example dagi $key haqiqiy secretga o'xshaydi (uzun va tasodifiy)"
      secret_issue=1
    fi
  done < <(grep -E '^[A-Za-z_][A-Za-z0-9_]*=' .env.example)
fi

[ "$secret_issue" -eq 0 ] && ok "Ochiq secret topilmadi"

# ---------------------------------------------------------------- 4. YAML fayllar

echo
info "YAML fayllar"

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
  warn "YAML tekshiruvchi topilmadi (python3+pyyaml, uv yoki yq) — o'tkazib yuborildi"
else
  yaml_bad=0
  yaml_n=0
  while IFS= read -r y; do
    yaml_n=$((yaml_n + 1))
    if ! parse_yaml "$y" 2>/dev/null; then
      report_problem "$(rel "$y") — noto'g'ri YAML"
      yaml_bad=$((yaml_bad + 1))
    fi
  done < <(find . \( -name '*.yml' -o -name '*.yaml' \) \
             -not -path './node_modules/*' -not -path './.venv/*' \
             -not -path '*/node_modules/*' -not -path '*/.venv/*' \
             -not -path './.git/*' | sort)
  [ "$yaml_bad" -eq 0 ] && ok "$yaml_n ta YAML fayl to'g'ri ($yaml_parser bilan tekshirildi)"
fi

# ---------------------------------------------------------------- 5. skriptlar bajariladigan

echo
info "Skriptlar"
script_issue=0
for s in scripts/*.sh; do
  [ -f "$s" ] || continue
  [ -x "$s" ] || { report_problem "$s bajariladigan emas: chmod +x $s"; script_issue=1; }
done
[ "$script_issue" -eq 0 ] && ok "Barcha skriptlar bajariladigan"

# ---------------------------------------------------------------- 6. lokal vositalar

if [ "$CI_MODE" -eq 0 ]; then
  echo
  info "Lokal vositalar"
  for tool in git docker make; do
    if has "$tool"; then ok "$tool"; else warn "$tool topilmadi"; fi
  done
  if has docker && docker compose version >/dev/null 2>&1; then
    ok "docker compose"
  elif has docker; then
    warn "docker compose (v2) topilmadi"
  fi
fi

# ---------------------------------------------------------------- 7. mavjud stacklar

echo
info "Topilgan stacklar"
found=0
while IFS= read -r dir; do
  stack="$(detect_stack "$dir")"
  [ "$stack" = none ] && continue
  ok "$(rel "$dir") → $stack"
  found=$((found + 1))
done < <(list_units)
[ "$found" -eq 0 ] && skip "Hali hech qanday kod qo'shilmagan (bo'sh template)"

# ---------------------------------------------------------------- natija

echo
if [ "$problems" -gt 0 ]; then
  fail "$problems ta muammo topildi"
  exit 1
fi
ok "Hammasi joyida"

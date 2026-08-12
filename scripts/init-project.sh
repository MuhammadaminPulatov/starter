#!/usr/bin/env bash
#
# Templateni haqiqiy loyihaga aylantiradi. Bir marta ishlatiladi.
#
#   ./scripts/init-project.sh              # interaktiv
#   ./scripts/init-project.sh --dry-run    # nima o'zgarishini ko'rsatadi, tegmaydi
#   ./scripts/init-project.sh --name my-app --keep web,api-node
#
# Har bir o'chirish oldidan tasdiq so'raladi.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

cd "$REPO_ROOT"

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
      sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'
      exit 0 ;;
    *) die "noma'lum argument: $1" ;;
  esac
done

[ "$DRY_RUN" -eq 1 ] && warn "DRY RUN — hech qanday fayl o'zgartirilmaydi"

confirm() {
  [ "$ASSUME_YES" -eq 1 ] && return 0
  [ "$DRY_RUN" -eq 1 ] && return 0
  printf '%s?%s %s [y/N] ' "$C_YELLOW" "$C_RESET" "$1"
  read -r ans </dev/tty
  [ "$ans" = "y" ] || [ "$ans" = "Y" ]
}

do_run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '%s  dry%s %s\n' "$C_DIM" "$C_RESET" "$*"
  else
    "$@"
  fi
}

# macOS (BSD) va Linux (GNU) sed farqini yashiradi
sed_inplace() {
  local expr="$1"; shift
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '%s  dry%s tahrirlanadi: %s\n' "$C_DIM" "$C_RESET" "$*"
    return
  fi
  if sed --version >/dev/null 2>&1; then
    sed -i -e "$expr" "$@"
  else
    sed -i '' -e "$expr" "$@"
  fi
}

# ---------------------------------------------------------------- 1. loyiha nomi

echo
info "1/5 — Loyiha nomi"

if [ -z "$PROJECT_NAME" ]; then
  if [ "$DRY_RUN" -eq 1 ] || [ "$ASSUME_YES" -eq 1 ]; then
    PROJECT_NAME="$(basename "$REPO_ROOT")"
    echo "     (avtomatik: $PROJECT_NAME)"
  else
    printf '     Loyiha nomi (kichik harf, chiziqcha bilan) [%s]: ' "$(basename "$REPO_ROOT")"
    read -r PROJECT_NAME </dev/tty
    PROJECT_NAME="${PROJECT_NAME:-$(basename "$REPO_ROOT")}"
  fi
fi

case "$PROJECT_NAME" in
  *[!a-zA-Z0-9_-]*) die "nomda faqat harf, raqam, '-' va '_' bo'lishi mumkin: '$PROJECT_NAME'" ;;
esac

# `project` placeholderini almashtirish (faqat aniq joylarda)
for f in .env.example docker-compose.yml README.md PROJECT_INDEX.md; do
  [ -f "$f" ] || continue
  sed_inplace "s/^APP_NAME=project$/APP_NAME=$PROJECT_NAME/; \
               s/^COMPOSE_PROJECT_NAME=project$/COMPOSE_PROJECT_NAME=$PROJECT_NAME/; \
               s/COMPOSE_PROJECT_NAME:-project/COMPOSE_PROJECT_NAME:-$PROJECT_NAME/; \
               s/^# Universal Project Template$/# $PROJECT_NAME/" "$f"
done
ok "Nom o'rnatildi: $PROJECT_NAME"

# ---------------------------------------------------------------- 2. stack tanlash

echo
info "2/5 — Kerakli stacklar"

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
    :   # tanlovsiz rejimda hech narsa o'chirilmaydi
  else
    if confirm "'$unit' kerakmi?"; then :; else to_delete="$to_delete $unit"; fi
  fi
done

if [ -n "$to_delete" ]; then
  warn "O'chiriladi:$to_delete"
  if confirm "Tasdiqlaysizmi?"; then
    for unit in $to_delete; do
      do_run rm -rf "$unit"
      ok "$unit o'chirildi"
      # Hujjatlardagi jadval qatorlarini ham olib tashlaymiz, aks holda
      # `make doctor` o'chirilgan papkaga ishora qiluvchi havolalarni topadi.
      for doc in README.md PROJECT_INDEX.md; do
        [ -f "$doc" ] || continue
        # Ajratgich sifatida ',' — chunki naqshning o'zi '|' va '/' belgilarini o'z ichiga oladi
        sed_inplace "\\,^|.*\`$unit\`,d" "$doc"
      done
    done
    ok "README.md va PROJECT_INDEX.md jadvallari yangilandi"
  else
    to_delete=""
    skip "Hech narsa o'chirilmadi"
  fi
else
  skip "Barcha stacklar saqlanadi"
fi

# ---------------------------------------------------------------- 3. .env

echo
info "3/5 — .env"

if [ -f .env ]; then
  skip ".env allaqachon mavjud — tegilmadi"
else
  do_run cp .env.example .env
  if [ "$DRY_RUN" -eq 0 ]; then
    if has openssl; then
      secret="$(openssl rand -hex 32)"
      sed_inplace "s|^JWT_SECRET=.*|JWT_SECRET=$secret|" .env
      ok "JWT_SECRET tasodifiy qiymat bilan to'ldirildi"
    else
      warn "openssl topilmadi — JWT_SECRET ni qo'lda to'ldiring"
    fi
    sed_inplace "s|^APP_NAME=.*|APP_NAME=$PROJECT_NAME|; s|^COMPOSE_PROJECT_NAME=.*|COMPOSE_PROJECT_NAME=$PROJECT_NAME|" .env
  fi
  ok ".env yaratildi"
  warn "Tashqi servis tokenlarini (.env) qo'lda to'ldiring"
fi

# ---------------------------------------------------------------- 4. git

echo
info "4/5 — Git"

if [ -d .git ]; then
  skip "Git repozitoriya allaqachon mavjud"
elif confirm "Git repozitoriya yaratilsinmi?"; then
  do_run git init -q
  do_run git add -A
  do_run git -c commit.gpgsign=false commit -q -m "chore: initial project structure from template"
  ok "Git repozitoriya yaratildi va birinchi commit qilindi"
else
  skip "Git o'tkazib yuborildi"
fi

# ---------------------------------------------------------------- 5. tozalash

echo
info "5/5 — Templateni tozalash"

if confirm "Bu skript o'zini o'chirsinmi? (template artefakti loyihada qolmaydi)"; then
  do_run rm -f "$REPO_ROOT/scripts/init-project.sh"
  ok "init-project.sh o'chirildi"
  warn "scripts/README.md va README.md dan unga havolani olib tashlang"
else
  skip "init-project.sh saqlandi"
fi

# ---------------------------------------------------------------- yakun

echo
ok "Tayyor: $PROJECT_NAME"
echo
echo "  Keyingi qadamlar:"
echo "    1. .env dagi maxfiy qiymatlarni to'ldiring"
echo "    2. docs/00-overview.md ga loyiha maqsadini yozing"
echo "    3. make setup && make dev"
echo "    4. make doctor"

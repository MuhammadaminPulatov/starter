#!/usr/bin/env bash
#
# Loyihani ishga tayyorlaydi: .env yaratadi va dependencylarni o'rnatadi.
# Bir necha marta ishga tushirish xavfsiz (idempotent).

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

cd "$REPO_ROOT"

info ".env tekshirilmoqda"
if [ -f .env ]; then
  ok ".env allaqachon mavjud — tegilmadi"
else
  [ -f .env.example ] || die ".env.example topilmadi"
  cp .env.example .env
  ok ".env yaratildi (.env.example dan)"
  warn "Maxfiy qiymatlarni (JWT_SECRET, tokenlar) .env ichida to'ldiring"
fi

echo
info "Dependencylar o'rnatilmoqda"
"$REPO_ROOT/scripts/run.sh" install

echo
info "Keyingi qadamlar"
echo "  make dev      — lokal infratuzilmani ko'tarish"
echo "  make doctor   — hamma narsa joyidami tekshirish"
echo "  make help     — barcha buyruqlar"

# Boshlash qoʻllanmasi

[English](01-getting-started.md) · **Oʻzbekcha** · [Русский](01-getting-started.ru.md)

## 1. Loyihani tayyorlash

```bash
# Templatedan yangi loyiha — bir marta bajariladi
./scripts/init-project.sh

# Mavjud loyihaga qoʻshilyapsizmi — bundan boshlang
make setup    # .env yaratadi va dependencylarni oʻrnatadi
make dev      # postgres va boshqa lokal servislarni ishga tushiradi
```

`.env` fayliga maxfiy qiymatlarni qoʻlda kiriting — u hech qachon repozitoriyaga
qoʻshilmaydi.

Navbat ham kerakmi? `make dev-queue` redis ni ham koʻtaradi.

## 2. Birinchi oʻqiladigan fayllar

1. [`README.uz.md`](../../README.uz.md)
2. [`PROJECT_INDEX.md`](../../PROJECT_INDEX.md) — nima qayerda
3. [`docs/00-overview.md`](../00-overview.md) — loyiha nima uchun kerak
4. [`docs/02-architecture.md`](../02-architecture.md) — qismlar qanday bogʻlangan
5. [`AGENTS.md`](../../AGENTS.md) — bu yerda kod yozish qoidalari

## 3. Tekshirish

```bash
make doctor   # env pariteti, sinigʻ havolalar, yetishmayotgan vositalar
make lint
make test
```

Qoʻlda tasdiqlang:

- Ilova lokal muhitda ochiladi.
- API hujjati ishlaydi (`/docs` yoki `docs/api/openapi.yaml`).
- Testlar muvaffaqiyatli yakunlanadi.

Template boʻsh boʻlgani uchun `make lint` va `make test` hech narsa qilmasligi
normal — ular nechta papka oʻtkazib yuborilganini yozib beradi.

## 4. Tilni tanlash

Skript chiqishi `STARTER_LANG` ga, u boʻlmasa tizim lokaliga qarab tanlanadi;
zaxira variant — ingliz tili:

```bash
STARTER_LANG=uz make doctor
```

## Biror narsa ishlamayaptimi?

[`04-troubleshooting.md`](04-troubleshooting.md) ga qarang.

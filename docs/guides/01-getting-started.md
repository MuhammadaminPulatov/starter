# Boshlash qo'llanmasi

## 1. Loyihani tayyorlash

```bash
# Yangi loyiha bo'lsa — bir marta bajariladi
./scripts/init-project.sh

# Mavjud loyihaga qo'shilyapsizmi — bundan boshlang
make setup    # .env yaratadi va dependencylarni o'rnatadi
make dev      # postgres va boshqa lokal servislarni ko'taradi
```

`.env` fayliga maxfiy qiymatlarni qo'lda kiriting — ular repozitoriyga hech qachon qo'shilmaydi.

## 2. Birinchi o'qiladigan fayllar

1. [`README.md`](../../README.md)
2. [`PROJECT_INDEX.md`](../../PROJECT_INDEX.md) — nima qayerda
3. [`docs/00-overview.md`](../00-overview.md) — loyiha nima uchun kerak
4. [`docs/02-architecture.md`](../02-architecture.md) — qismlar qanday bog'langan
5. [`AGENTS.md`](../../AGENTS.md) — kod yozish qoidalari

## 3. Tekshiruv

```bash
make doctor   # env pariteti, sinig' havolalar, kerakli vositalar
make lint
make test
```

Qo'lda tasdiqlang:

- Ilova lokal muhitda ochiladi.
- API hujjati ishlaydi (`/docs` yoki `docs/api/openapi.yaml`).
- Testlar muvaffaqiyatli yakunlanadi.

Biror narsa ishlamasa: [`04-troubleshooting.md`](04-troubleshooting.md).

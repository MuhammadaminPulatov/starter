# Muammolarni hal qilish

Birinchi qadam har doim bir xil:

```bash
make doctor
```

U `.env` pariteti, sinig' havolalar va yetishmayotgan vositalarni ko'rsatadi.

## Ilova ishga tushmasa

1. `.env` qiymatlarini `.env.example` bilan solishtiring (`make doctor` shuni tekshiradi).
2. Database va boshqa kerakli containerlar ishlayotganini tekshiring: `docker compose ps`.
3. Ilova loglaridagi **birinchi** xatoni toping — oxirgisini emas: `docker compose logs --tail=200`.

## `make dev` port xatosi bersa

5432 yoki 6379 port band. `.env` da `POSTGRES_PORT` yoki `REDIS_PORT` ni o'zgartiring.

## Container ichidan databasega ulanib bo'lmasa

`DATABASE_URL` da `localhost` turibdi. Container ichidan host nomi `postgres` bo'lishi kerak — `.env.example` dagi izohga qarang.

## API xato qaytarsa

1. `docs/api/openapi.yaml` yoki Swagger orqali request formatini tekshiring.
2. Authentication va ruxsatlarni tekshiring.
3. Service loglari va database ulanishini tekshiring.

## `make lint` / `make test` hech narsa qilmasa

Bu normal — hali kod yo'q. Skript nechta papka o'tkazib yuborilganini yozib beradi. Kod qo'shilgach (`package.json`, `pyproject.toml`, `go.mod` bilan) u avtomatik topiladi.

## Production muammosi

[`docs/operations/runbook.md`](../operations/runbook.md) bo'yicha harakat qiling va hodisadan keyin sababini yozib qo'ying.

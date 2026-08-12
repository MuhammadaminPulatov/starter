# services/worker

Fon vazifalari: navbat (queue), cron, uzoq davom etadigan ishlar, email/notification yuborish.

**Qanday boshlash**

```bash
# Python
uv add celery redis        # yoki arq, dramatiq
# Node
npm i bullmq ioredis
```

**Broker:** lokal redis `make dev` bilan avtomatik ko'tarilmaydi — u `queue` profilida:

```bash
docker compose --profile queue up -d
```

`.env` dagi `REDIS_URL` ni ishlating.

**Qoida:** har bir vazifa idempotent bo'lsin — ikki marta bajarilsa ham natija bir xil bo'lishi kerak.

**Ishlatmasangiz:** bu papkani o'chiring.

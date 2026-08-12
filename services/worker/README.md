# services/worker

Background work: queues, cron, long-running jobs, sending email and
notifications.

**Getting started**

```bash
# Python
uv add celery redis        # or arq, dramatiq
# Node
npm i bullmq ioredis
```

**Broker:** redis is not started by `make dev` — it lives in the `queue` profile:

```bash
make dev-queue
```

Use `REDIS_URL` from `.env`.

**Rule:** make every job idempotent — running it twice must produce the same
result.

**Not using it?** Delete this directory.

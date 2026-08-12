# Troubleshooting

The first step is always the same:

```bash
make doctor
```

It reports `.env` parity, broken documentation links and missing tools.

## The app will not start

1. Compare `.env` against `.env.example` (`make doctor` does this for you).
2. Check that the containers are running: `docker compose ps`.
3. Find the **first** error in the logs, not the last:
   `docker compose logs --tail=200`.

## `make dev` reports a port conflict

Port 5432 or 6379 is already in use. Change `POSTGRES_PORT` or `REDIS_PORT`
in `.env`.

## Cannot reach the database from inside a container

`DATABASE_URL` still points at `localhost`. From inside a container the host
name is `postgres` — see the comment in `.env.example`.

## `make lint` / `make test` do nothing

That is expected while the template is empty. The script reports how many
directories were skipped. Once you add code with a `package.json`,
`pyproject.toml` or `go.mod`, it is picked up automatically.

## Script messages are in the wrong language

Set the language explicitly: `STARTER_LANG=en|uz|ru make doctor`. Without it,
the language is detected from your system locale and falls back to English.

## A production problem

Follow [`docs/operations/runbook.md`](../operations/runbook.md) and write down
the cause afterwards.

# Getting started

**English** · [Oʻzbekcha](01-getting-started.uz.md) · [Русский](01-getting-started.ru.md)

## 1. Prepare the project

```bash
# New project from the template — run once
./scripts/init-project.sh

# Joining an existing project — start here
make setup    # creates .env and installs dependencies
make dev      # starts postgres and other local services
```

Fill in the secret values in `.env` by hand — that file is never committed.

Need the queue too? `make dev-queue` also starts redis.

## 2. Read these first

1. [`README.md`](../../README.md)
2. [`PROJECT_INDEX.md`](../../PROJECT_INDEX.md) — what lives where
3. [`docs/00-overview.md`](../00-overview.md) — why the project exists
4. [`docs/02-architecture.md`](../02-architecture.md) — how the pieces connect
5. [`AGENTS.md`](../../AGENTS.md) — the rules for writing code here

## 3. Verify

```bash
make doctor   # env parity, broken links, missing tools
make lint
make test
```

Confirm by hand:

- The application opens locally.
- The API documentation works (`/docs`, or `docs/api/openapi.yaml`).
- The tests pass.

`make lint` and `make test` doing nothing is expected while the template is
empty — they report how many directories were skipped.

## 4. Set the language

Script output follows `STARTER_LANG`, or your system locale, falling back to
English:

```bash
STARTER_LANG=uz make doctor
```

## Something not working?

See [`04-troubleshooting.md`](04-troubleshooting.md).

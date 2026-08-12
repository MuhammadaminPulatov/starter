# Project Index

A map of the repository. Update this file whenever you add a directory or module.

## Entry points

| Question | File |
| --- | --- |
| What does this project do? | `docs/00-overview.md` |
| What has to be built? | `docs/01-requirements.md` |
| How do the pieces fit together? | `docs/02-architecture.md` |
| How do I get started? | `docs/guides/01-getting-started.md` |
| How do I work day to day? | `docs/guides/02-development-workflow.md` |
| Something is broken | `docs/guides/04-troubleshooting.md` |
| Production is on fire | `docs/operations/runbook.md` |
| Agent rules | `AGENTS.md` |

## Directories

### `apps/` — user-facing applications

| Directory | Purpose | Status |
| --- | --- | --- |
| `apps/web` | Website, admin panel, dashboard | empty |
| `apps/mobile` | iOS/Android application | empty |
| `apps/bot` | Telegram / Discord / Slack bot | empty |

### `services/` — APIs and background work

| Directory | Purpose | Status |
| --- | --- | --- |
| `services/api-node` | Node.js/TypeScript API | empty |
| `services/api-python` | Python FastAPI service | empty |
| `services/worker` | Queues, cron, background jobs | empty |

### `packages/` — shared, reusable code

| Directory | Purpose | Status |
| --- | --- | --- |
| `packages/ui` | Shared UI components | empty |
| `packages/types` | Shared types and schemas | empty |
| `packages/sdk` | API client library | empty |
| `packages/config` | Shared lint/tsconfig/build config | empty |

### Everything else

| Directory | Purpose |
| --- | --- |
| `docs/` | Documentation, decisions (ADR), guides, runbook |
| `infrastructure/` | Docker, nginx, terraform, monitoring, database config |
| `design/` | Figma links, brand, exported assets |
| `scripts/` | `setup`, `run`, `doctor`, `init-project` automation |
| `.github/` | CI workflow, PR/issue templates, dependabot |

## Important root files

| File | Purpose |
| --- | --- |
| `Makefile` | Every day-to-day command (`make help`) |
| `docker-compose.yml` | Local infrastructure (postgres, redis) |
| `.env.example` | The full list of environment variables |
| `scripts/run.sh` | Detects each stack and runs lint/test/build |
| `scripts/doctor.sh` | Checks repository health (CI calls it too) |
| `scripts/lang/` | Message catalogues for English, Uzbek and Russian |

## About the status column

`empty` means the directory contains only a `README.md`. To start using it,
follow the init command in that README and update this table. If you do not need
it, delete the directory — nothing breaks.

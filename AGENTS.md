# Agent rules

This file is the binding contract for AI agents (Claude Code, Codex, Cursor and
others) and for new contributors. `CLAUDE.md` imports it, so edit the rules only
here.

## Before writing code

1. Read `PROJECT_INDEX.md` to learn what each directory is for.
2. Read the relevant documents: `docs/01-requirements.md`,
   `docs/02-architecture.md` and, if it exists, `docs/modules/<module>.md`.
3. Search the existing code first. Before writing a new utility, check whether
   `packages/` already has something equivalent.

## While writing code

- Match the surrounding style, naming and architecture. Do not introduce a new
  pattern where an established one already fits.
- Put code where it belongs: user-facing apps in `apps/`, business logic and
  APIs in `services/`, reusable code in `packages/`.
- Add or update a test with every change.
- **Never write a secret, token, password or API key into code, tests or logs.**
  They live only in `.env`; `.env.example` gets an empty placeholder.
- When you add an environment variable, add it to `.env.example` as well — CI
  verifies that the two files agree.

## After writing code

Run these before opening a pull request:

```bash
make lint
make test
make build
make doctor
```

Documentation that must be kept in sync:

| Change | File to update |
| --- | --- |
| New directory or module | `PROJECT_INDEX.md` |
| API endpoint | `docs/api/openapi.yaml` |
| Database schema | `docs/04-database.md` plus a migration |
| Significant technical decision | a new ADR in `docs/adr/` |
| User-visible change | `CHANGELOG.md` (`Unreleased` section) |

## Do not

- Disable a test or a linter "temporarily".
- Swallow errors with an empty `try/except` or `catch {}`.
- Commit `.env`, dumps, backups or production data.
- Mix several unrelated changes into one pull request.
- Perform a large refactor that was not requested.

## About this template

This is a multi-stack starter. Every directory under `apps/` and `services/` is
**optional**. When one is deleted, the `make` targets and CI keep working —
all automation is detection-based, driven by manifest files. For that reason,
never add a hardcoded path to the automation.

Script output is available in English, Uzbek and Russian via `STARTER_LANG`;
message catalogues live in `scripts/lang/`. If you add a user-facing string to a
script, add the key to **all three** catalogues.

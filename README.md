<div align="center">

# Universal Project Starter

**A multi-stack project skeleton where the automation actually works —
and never lies to you about it.**

[![CI](https://github.com/MuhammadaminPulatov/starter/actions/workflows/ci.yml/badge.svg)](https://github.com/MuhammadaminPulatov/starter/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Template](https://img.shields.io/badge/GitHub-template-blue.svg)](https://github.com/MuhammadaminPulatov/starter/generate)
[![Languages](https://img.shields.io/badge/docs-EN%20%7C%20UZ%20%7C%20RU-orange.svg)](#documentation)

**English** · [Oʻzbekcha](README.uz.md) · [Русский](README.ru.md)

</div>

---

Most starter templates hand you empty folders and a CI file that runs
`echo "configure me later"`. Every pull request is green, and the green means
nothing. This one is built the other way round: nothing claims to have run
unless it ran, and everything adapts to the stacks you actually keep.

## Why this template

| | What you get |
| --- | --- |
| **No false green** | `make lint` on an empty repo prints *"nothing to run — 10 dirs skipped"* and exits 0. It never reports success for work it did not do. |
| **Delete what you don't need** | Remove `apps/mobile` or `services/api-python` and everything keeps working. All automation is detection-based, driven by manifest files — no hardcoded paths. |
| **CI that means something on day one** | The `structure` job checks documentation links, `.env` parity, secret hygiene and YAML validity — real work even before you write a line of code. |
| **Multi-language tooling** | Script output in English, Uzbek and Russian via `STARTER_LANG`. |
| **Agent-ready** | `AGENTS.md` + `CLAUDE.md` + `PROJECT_INDEX.md` give AI coding agents a real contract and a map, instead of letting them guess. |
| **One health command** | `make doctor` catches broken doc links, `.env` drift, secrets left in `.env.example`, invalid YAML and non-executable scripts. |

## Quick start

Click **[Use this template](https://github.com/MuhammadaminPulatov/starter/generate)**
(or clone the repository), then:

```bash
./scripts/init-project.sh   # name, stack selection, .env, git init
make setup                  # install dependencies
make dev                    # start local infrastructure
make doctor                 # verify everything is in place
```

`make help` lists every command. Next: describe the project in
[`docs/00-overview.md`](docs/00-overview.md).

> Try `./scripts/init-project.sh --dry-run` first — it shows exactly what would
> change without touching a single file.

## What it looks like

```console
$ make lint
 skip apps/bot: no manifest found (package.json / pyproject.toml / go.mod)
==> apps/web: npm run lint
  ok apps/web
==> services/api-python: uv run --with ruff ruff check .
  ok services/api-python

  ok lint: 2 succeeded, 8 skipped (of 10 dirs)
```

```console
$ make doctor
==> Internal documentation links
  ok 149 links checked, none broken
==> Environment variables
  ok .env and .env.example keys match
==> Secret hygiene
  ok No exposed secrets found
==> YAML files
  ok 5 YAML files are valid (checked with python3)
==> Detected stacks
  ok apps/web → node
  ok services/api-python → python

  ok Everything is in order
```

## Supported stacks

Detection is driven purely by the manifest file found in each directory:

| Manifest | Stack | lint | test | build |
| --- | --- | --- | --- | --- |
| `package.json` | Node / TypeScript | `<pm> run lint` | `<pm> run test` | `<pm> run build` |
| `pyproject.toml` | Python | `ruff check` | `pytest` | — |
| `go.mod` | Go | `go vet ./...` | `go test ./...` | `go build ./...` |
| `Cargo.toml` | Rust | `cargo clippy` | `cargo test` | `cargo build` |
| `pubspec.yaml` | Dart / Flutter | `flutter analyze` | `flutter test` | — |

The Node package manager comes from the lockfile — pnpm, yarn, bun or npm.
Adding another stack means one function in [`scripts/run.sh`](scripts/run.sh).

## Structure

```
apps/          user-facing applications   (web, mobile, bot)
services/      APIs and background work   (api-node, api-python, worker)
packages/      shared reusable code       (ui, types, sdk, config)
docs/          documentation, ADRs, guides, runbook
infrastructure/ docker, nginx, terraform, monitoring, database
design/        figma links, brand, exported assets
scripts/       setup, run, doctor, init-project + i18n catalogues
```

Every directory under `apps/` and `services/` is **optional** and carries a
`README.md` explaining what belongs there, how to initialise it, and that
deleting it breaks nothing.

## Commands

| Command | What it does |
| --- | --- |
| `make setup` | Create `.env` and install dependencies |
| `make dev` | Start postgres |
| `make dev-queue` | Start postgres and redis (for the worker) |
| `make lint` / `test` / `build` | Run the task for every detected stack |
| `make doctor` | Check repository health |
| `make down` / `logs` / `ps` | Container lifecycle |
| `make clean` | Remove containers and volumes (asks first) |

## Language

Script output follows `STARTER_LANG`, or your system locale, falling back to
English:

```bash
STARTER_LANG=uz make doctor
STARTER_LANG=ru make lint
```

Catalogues live in [`scripts/lang/`](scripts/lang/). Adding a language means
copying `en.sh` and translating the values — see
[CONTRIBUTING.md](CONTRIBUTING.md).

## Documentation

| Topic | English | Oʻzbekcha | Русский |
| --- | --- | --- | --- |
| Overview | [README.md](README.md) | [README.uz.md](README.uz.md) | [README.ru.md](README.ru.md) |
| Getting started | [guide](docs/guides/01-getting-started.md) | [qoʻllanma](docs/guides/01-getting-started.uz.md) | [руководство](docs/guides/01-getting-started.ru.md) |
| Contributing | [CONTRIBUTING.md](CONTRIBUTING.md) | [CONTRIBUTING.uz.md](CONTRIBUTING.uz.md) | [CONTRIBUTING.ru.md](CONTRIBUTING.ru.md) |

Reference documentation is maintained in English:
[project map](PROJECT_INDEX.md) ·
[architecture](docs/02-architecture.md) ·
[API conventions](docs/03-api.md) ·
[deployment](docs/05-deployment.md) ·
[runbook](docs/operations/runbook.md) ·
[agent rules](AGENTS.md)

## Contributing

Issues and pull requests are welcome — including translation fixes.
See [CONTRIBUTING.md](CONTRIBUTING.md), and
[SECURITY.md](SECURITY.md) for reporting a vulnerability.

## License

[MIT](LICENSE) — use it, change it, ship it.

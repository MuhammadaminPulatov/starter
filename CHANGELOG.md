# Changelog

All notable, user-visible changes are recorded here.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
versioning: [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Section names: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`.

## [Unreleased]

## [0.1.0] — 2026-08-13

First public release.

### Added

- Multi-stack project skeleton: `apps/`, `services/`, `packages/`,
  `infrastructure/`, `design/`, `docs/`. Every app and service directory is
  optional and documents itself.
- Detection-based automation (`scripts/run.sh`): Node/TypeScript, Python, Go,
  Rust and Dart are recognised from their manifest files. A `--stack` filter
  keeps each CI job to its own toolchain.
- `scripts/doctor.sh` health check: documentation links, `.env`/`.env.example`
  parity, a secret tripwire, YAML validity and script permissions.
- `scripts/init-project.sh`: turns the template into a project — name, stack
  selection, `.env` with a generated `JWT_SECRET`, `git init`. Supports
  `--dry-run`.
- `Makefile` with `setup`, `dev`, `dev-queue`, `down`, `logs`, `ps`, `lint`,
  `lint-sh`, `test`, `build`, `doctor`, `clean` and a self-documenting `help`.
- `docker-compose.yml` driven entirely by `.env`, with health checks; redis
  behind a `queue` profile; `docker-compose.override.yml.example` for app
  services.
- CI that does real work on an empty repository: a `structure` job (doctor,
  compose config, ShellCheck) plus `node`/`python` jobs that run only when that
  stack exists, aggregated by `ci-ok`.
- Script output in English, Uzbek and Russian via `STARTER_LANG`, with catalogues
  in `scripts/lang/` and fallback to the system locale, then English.
- Agent contract for AI coding tools: `AGENTS.md`, `CLAUDE.md` and
  `PROJECT_INDEX.md`.
- Documentation set: overview, requirements, architecture, API conventions,
  database, deployment policy, guides, operations runbook, ADR and module
  templates. `README`, the getting-started guide and `CONTRIBUTING` are
  available in all three languages.
- Repository hygiene: MIT license, `.gitattributes`, `.editorconfig`, `.nvmrc`,
  `.python-version`, dependabot, CODEOWNERS, issue and pull request templates,
  `.shellcheckrc`.

[Unreleased]: https://github.com/MuhammadaminPulatov/starter/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/MuhammadaminPulatov/starter/releases/tag/v0.1.0

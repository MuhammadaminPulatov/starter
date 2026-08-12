# Contributing

**English** · [Oʻzbekcha](CONTRIBUTING.uz.md) · [Русский](CONTRIBUTING.ru.md)

Thanks for helping. Issues, pull requests and translation fixes are all welcome.

## Workflow

1. Create a branch per task: `feature/login`, `fix/payment-error`.
2. Use conventional commits: `feat: add login`, `fix: validate phone number`.
   Common types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `ci`.
3. Keep pull requests small and focused on one topic.
4. Run the checks before opening a PR:

   ```bash
   make lint && make test && make build && make doctor
   ```

5. Record significant technical decisions as an ADR in `docs/adr/`.

## What CI checks

| Job | What it verifies |
| --- | --- |
| `structure` | Documentation links, `.env.example` parity, secret hygiene, YAML validity |
| `node` | Runs only when a `package.json` exists: install, lint, test, build |
| `python` | Runs only when a `pyproject.toml` exists: install, lint, test |
| `ci-ok` | Aggregates the above — make this one the required check |

A skipped `node`/`python` job is expected when that stack is absent; it is not
a failure.

## Adding a language

Script output lives in `scripts/lang/`. To add one:

1. Copy `scripts/lang/en.sh` to `scripts/lang/<code>.sh`.
2. Translate the values. Keep **every key**, and keep the **number and order of
   `%s` placeholders identical** — they are printf format strings.
3. Test it: `STARTER_LANG=<code> make doctor` and `STARTER_LANG=<code> make lint`.
4. Add the language to the `STARTER_LANG` lists in `README*.md` and
   `scripts/README.md`.

Key parity is easy to verify:

```bash
diff <(grep -o '^T_[A-Z_]*' scripts/lang/en.sh | sort) \
     <(grep -o '^T_[A-Z_]*' scripts/lang/<code>.sh | sort)
```

> Note: bash single-quoted strings cannot contain an escaped `'`. If your
> language needs apostrophes, use the correct Unicode letters — the Uzbek
> catalogue uses `oʻ`, `gʻ` (U+02BB) and `ʼ` (U+02BC).

## Changing the scripts

- All user-facing text goes through the message catalogue — no hardcoded
  strings.
- Keep it compatible with **bash 3.2** (the default on macOS): no associative
  arrays, no `mapfile`.
- Never hardcode a path to a specific app or service. Automation is
  detection-based so that any directory can be deleted.
- Make `doctor.sh` checks report the problem *and* how to fix it.

## Translating documentation

Reference documentation is maintained in English. Three documents are
translated: `README`, `docs/guides/01-getting-started.md` and `CONTRIBUTING.md`.
If you change one of them, please update the other language versions or say in
the PR that they still need updating.

## Reporting problems

- Bugs and features: use the issue templates.
- Security: **do not** open a public issue — see [SECURITY.md](SECURITY.md).

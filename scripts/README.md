# Scripts

All the automation for this project. The `Makefile` delegates to these scripts;
you can also call them directly.

| Script | What it does |
| --- | --- |
| `init-project.sh` | Turns the template into a real project: name, stack selection, `.env`, `git init`. Run once. |
| `setup.sh` | Creates `.env` and installs dependencies (`make setup`). |
| `run.sh` | Detects each directory's stack and runs `lint`/`test`/`build`/`install` (`make lint` etc.). |
| `doctor.sh` | Checks repository health: links, env parity, secrets, YAML (`make doctor`, and CI). |
| `lib.sh` | Shared helpers and the language loader. Not called directly. |
| `lang/` | Message catalogues: `en.sh`, `uz.sh`, `ru.sh`. |

## How detection works

`run.sh` walks `apps/*`, `services/*` and `packages/*` and picks the toolchain
from the manifest file it finds:

| Manifest | Stack | lint | test | build |
| --- | --- | --- | --- | --- |
| `package.json` | node | `<pm> run lint` | `<pm> run test` | `<pm> run build` |
| `pyproject.toml` | python | `ruff check` | `pytest` | — |
| `go.mod` | go | `go vet ./...` | `go test ./...` | `go build ./...` |
| `Cargo.toml` | rust | `cargo clippy` | `cargo test` | `cargo build` |
| `pubspec.yaml` | dart | `flutter analyze` | `flutter test` | — |

For Node the package manager comes from the lockfile (`pnpm-lock.yaml` → pnpm,
`yarn.lock` → yarn, `bun.lock*` → bun, otherwise npm).

A directory without a manifest is skipped, and that is printed explicitly — it
is never counted as success.

### The `--stack` filter

```bash
./scripts/run.sh --stack node lint     # node directories only
./scripts/run.sh --stack python test   # python directories only
```

In CI each job installs only its own toolchain (the node job has no `uv`, the
python job does not need `npm`). Without the filter the node job would also try
to handle the python directory and fail, so CI always passes `--stack`.

## Language

Script output is available in English, Uzbek and Russian:

```bash
STARTER_LANG=uz make doctor
STARTER_LANG=ru ./scripts/run.sh lint
```

Without `STARTER_LANG` the language is detected from the system locale
(`LC_ALL` / `LC_MESSAGES` / `LANG`) and falls back to English.

Message catalogues live in `scripts/lang/`. `en.sh` is the reference: every
language file must define the **same keys** with the **same number and order of
`%s` placeholders`**. When you add a user-facing string, add it to all three.

> Note: bash single-quoted strings cannot contain an escaped `'`. The Uzbek
> catalogue therefore uses the correct Uzbek letters `oʻ`, `gʻ` (U+02BB) and
> `ʼ` (U+02BC), which is also the proper orthography.

## Adding a script

1. Create `scripts/<name>.sh` starting with
   `source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"`.
2. `chmod +x` it — `doctor.sh` checks this.
3. Add a `Makefile` target if useful (with a `## comment`, which shows up in
   `make help`).

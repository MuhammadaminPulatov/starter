# Scripts

Loyihaning barcha avtomatikasi. `Makefile` shu skriptlarga delegatsiya qiladi — to'g'ridan-to'g'ri ham chaqirsa bo'ladi.

| Skript | Nima qiladi |
| --- | --- |
| `init-project.sh` | Templateni haqiqiy loyihaga aylantiradi: nom, kerakli stacklar, `.env`, `git init`. Bir marta ishlatiladi. |
| `setup.sh` | `.env` yaratadi va dependencylarni o'rnatadi (`make setup`). |
| `run.sh` | Har papkani aniqlab `lint`/`test`/`build`/`install` bajaradi (`make lint` va h.k.). |
| `doctor.sh` | Repo sog'lig'ini tekshiradi: havolalar, env pariteti, secretlar (`make doctor`, CI ham). |
| `lib.sh` | Umumiy funksiyalar. To'g'ridan-to'g'ri chaqirilmaydi. |

## Detection qanday ishlaydi

`run.sh` `apps/*`, `services/*`, `packages/*` bo'ylab yuradi va manifest fayliga qarab vositani tanlaydi:

| Manifest | Stack | lint | test | build |
| --- | --- | --- | --- | --- |
| `package.json` | node | `<pm> run lint` | `<pm> run test` | `<pm> run build` |
| `pyproject.toml` | python | `ruff check` | `pytest` | — |
| `go.mod` | go | `go vet ./...` | `go test ./...` | `go build ./...` |
| `Cargo.toml` | rust | `cargo clippy` | `cargo test` | `cargo build` |
| `pubspec.yaml` | dart | `flutter analyze` | `flutter test` | — |

Node uchun package manager lockfayldan aniqlanadi (`pnpm-lock.yaml` → pnpm, `yarn.lock` → yarn, `bun.lock*` → bun, aks holda npm).

Manifest yo'q papka o'tkazib yuboriladi va bu ekranda aniq ko'rsatiladi — hech qachon "muvaffaqiyatli" deb hisoblanmaydi.

### `--stack` filtri

```bash
./scripts/run.sh --stack node lint     # faqat node papkalari
./scripts/run.sh --stack python test   # faqat python papkalari
```

CI da har bir job faqat o'z tilining vositalarini o'rnatadi (node job'ida `uv` yo'q, python job'ida `npm` kerak emas). Filtrsiz node job'i python papkasiga ham urinardi va xato berardi — shuning uchun CI har doim `--stack` bilan chaqiradi.

## Yangi skript qo'shish

1. `scripts/` ichida `*.sh` fayl yarating, boshiga `source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"` qo'ying.
2. `chmod +x` qiling — `doctor.sh` buni tekshiradi.
3. Kerak bo'lsa `Makefile` ga target qo'shing (`## izoh` bilan — u `make help` da chiqadi).

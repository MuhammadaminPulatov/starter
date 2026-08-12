<div align="center">

# Universal Project Starter

**Avtomatikasi haqiqatan ishlaydigan — va hech qachon yolgʻon gapirmaydigan
koʻp-stack loyiha skeleti.**

[![CI](https://github.com/MuhammadaminPulatov/starter/actions/workflows/ci.yml/badge.svg)](https://github.com/MuhammadaminPulatov/starter/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Template](https://img.shields.io/badge/GitHub-template-blue.svg)](https://github.com/MuhammadaminPulatov/starter/generate)
[![Languages](https://img.shields.io/badge/docs-EN%20%7C%20UZ%20%7C%20RU-orange.svg)](#hujjatlar)

[English](README.md) · **Oʻzbekcha** · [Русский](README.ru.md)

</div>

---

Koʻpchilik starter templatelar sizga boʻsh papkalar va `echo "keyinroq
sozlaysiz"` deb yozadigan CI beradi. Har PR yashil boʻladi, lekin bu yashil
rang hech narsani anglatmaydi. Bu template teskari tamoyilga qurilgan:
bajarilmagan ish hech qachon "bajarildi" deb koʻrsatilmaydi, va hamma narsa siz
saqlab qolgan stacklarga moslashadi.

## Nima uchun aynan shu template

| | Nima olasiz |
| --- | --- |
| **Yolgʻon yashil signal yoʻq** | Boʻsh repoda `make lint` *"bajarish uchun hech narsa topilmadi — 10 papka oʻtkazib yuborildi"* deb yozadi va 0 qaytaradi. Qilmagan ishini muvaffaqiyat deb koʻrsatmaydi. |
| **Keraksizini oʻchiring** | `apps/mobile` yoki `services/api-python` ni oʻchirsangiz, hammasi ishlayveradi. Avtomatika manifest fayliga qarab aniqlashga asoslangan — qattiq yoʻl yoʻq. |
| **Birinchi kundanoq mazmunli CI** | `structure` job hujjat havolalarini, `.env` paritetini, secret gigienasini va YAML toʻgʻriligini tekshiradi — hali bitta qator kod yozilmasdan turib ham haqiqiy ish. |
| **Koʻp tilli vositalar** | Skript chiqishi `STARTER_LANG` orqali ingliz, oʻzbek va rus tilida. |
| **AI agentlarga tayyor** | `AGENTS.md` + `CLAUDE.md` + `PROJECT_INDEX.md` agentlarga taxmin qilish oʻrniga aniq kontrakt va xarita beradi. |
| **Bitta sogʻliq buyrugʻi** | `make doctor` sinigʻ havolalarni, `.env` mos kelmasligini, `.env.example` da qolib ketgan secretni, notoʻgʻri YAML va bajarilmaydigan skriptlarni topadi. |

## Tez boshlash

**[Use this template](https://github.com/MuhammadaminPulatov/starter/generate)**
tugmasini bosing (yoki repozitoriyani klon qiling), soʻng:

```bash
./scripts/init-project.sh   # nom, stack tanlash, .env, git init
make setup                  # dependencylarni oʻrnatadi
make dev                    # lokal infratuzilmani koʻtaradi
make doctor                 # hamma narsa joyidami tekshiradi
```

`make help` — barcha buyruqlar roʻyxati. Keyingi qadam: loyiha maqsadini
[`docs/00-overview.md`](docs/00-overview.md) ga yozing.

> Avval `./scripts/init-project.sh --dry-run` ni sinang — u bitta faylga ham
> tegmasdan nima oʻzgarishini aniq koʻrsatadi.

## Qanday koʻrinadi

```console
$ STARTER_LANG=uz make lint
 skip apps/bot: manifest fayli yoʻq (package.json / pyproject.toml / go.mod)
==> apps/web: npm run lint
  ok apps/web
==> services/api-python: uv run --with ruff ruff check .
  ok services/api-python

  ok lint: 2 muvaffaqiyatli, 8 oʻtkazib yuborildi (10 papkadan)
```

```console
$ STARTER_LANG=uz make doctor
==> Hujjatlardagi ichki havolalar
  ok 149 havola tekshirildi, sinigʻi yoʻq
==> Environment oʻzgaruvchilari
  ok .env va .env.example kalitlari mos
==> Secret gigienasi
  ok Ochiq secret topilmadi
==> YAML fayllar
  ok 5 ta YAML fayl toʻgʻri (python3 bilan tekshirildi)
==> Topilgan stacklar
  ok apps/web → node
  ok services/api-python → python

  ok Hammasi joyida
```

## Qoʻllab-quvvatlanadigan stacklar

Aniqlash faqat papkadagi manifest fayliga qarab amalga oshiriladi:

| Manifest | Stack | lint | test | build |
| --- | --- | --- | --- | --- |
| `package.json` | Node / TypeScript | `<pm> run lint` | `<pm> run test` | `<pm> run build` |
| `pyproject.toml` | Python | `ruff check` | `pytest` | — |
| `go.mod` | Go | `go vet ./...` | `go test ./...` | `go build ./...` |
| `Cargo.toml` | Rust | `cargo clippy` | `cargo test` | `cargo build` |
| `pubspec.yaml` | Dart / Flutter | `flutter analyze` | `flutter test` | — |

Node uchun package manager lockfayldan aniqlanadi — pnpm, yarn, bun yoki npm.
Yangi stack qoʻshish — [`scripts/run.sh`](scripts/run.sh) da bitta funksiya.

## Tuzilishi

```
apps/          foydalanuvchi koʻradigan ilovalar  (web, mobile, bot)
services/      API va fon jarayonlari             (api-node, api-python, worker)
packages/      qayta ishlatiladigan umumiy kod    (ui, types, sdk, config)
docs/          hujjatlar, ADR, qoʻllanmalar, runbook
infrastructure/ docker, nginx, terraform, monitoring, database
design/        figma havolalari, brend, eksport assetlar
scripts/       setup, run, doctor, init-project + i18n kataloglari
```

`apps/` va `services/` ichidagi har bir papka **ixtiyoriy** va oʻz `README.md`
fayliga ega: u yerda nima kelishi, qanday boshlash va oʻchirsangiz hech narsa
sinmasligi yozilgan.

## Buyruqlar

| Buyruq | Nima qiladi |
| --- | --- |
| `make setup` | `.env` yaratadi va dependencylarni oʻrnatadi |
| `make dev` | Postgres ni ishga tushiradi |
| `make dev-queue` | Postgres va redis (worker uchun) |
| `make lint` / `test` / `build` | Har bir topilgan stack uchun vazifani bajaradi |
| `make doctor` | Repo sogʻligʻini tekshiradi |
| `make down` / `logs` / `ps` | Containerlarni boshqarish |
| `make clean` | Containerlar va volumelarni oʻchiradi (avval soʻraydi) |

## Til

Skript chiqishi `STARTER_LANG` ga, u boʻlmasa tizim lokaliga qarab tanlanadi;
zaxira variant — ingliz tili:

```bash
STARTER_LANG=uz make doctor
STARTER_LANG=ru make lint
```

Kataloglar [`scripts/lang/`](scripts/lang/) ichida. Yangi til qoʻshish uchun
`en.sh` dan nusxa olib qiymatlarni tarjima qiling —
[CONTRIBUTING.uz.md](CONTRIBUTING.uz.md) ga qarang.

## Hujjatlar

| Mavzu | English | Oʻzbekcha | Русский |
| --- | --- | --- | --- |
| Umumiy | [README.md](README.md) | [README.uz.md](README.uz.md) | [README.ru.md](README.ru.md) |
| Boshlash | [guide](docs/guides/01-getting-started.md) | [qoʻllanma](docs/guides/01-getting-started.uz.md) | [руководство](docs/guides/01-getting-started.ru.md) |
| Hissa qoʻshish | [CONTRIBUTING.md](CONTRIBUTING.md) | [CONTRIBUTING.uz.md](CONTRIBUTING.uz.md) | [CONTRIBUTING.ru.md](CONTRIBUTING.ru.md) |

Maʼlumotnoma hujjatlari ingliz tilida yuritiladi:
[loyiha xaritasi](PROJECT_INDEX.md) ·
[arxitektura](docs/02-architecture.md) ·
[API qoidalari](docs/03-api.md) ·
[deploy](docs/05-deployment.md) ·
[runbook](docs/operations/runbook.md) ·
[agent qoidalari](AGENTS.md)

## Hissa qoʻshish

Issue va pull requestlar ochiq — tarjima tuzatishlari ham.
[CONTRIBUTING.uz.md](CONTRIBUTING.uz.md) ga qarang; xavfsizlik muammosi uchun
[SECURITY.md](SECURITY.md).

## Litsenziya

[MIT](LICENSE) — ishlating, oʻzgartiring, chiqaring.

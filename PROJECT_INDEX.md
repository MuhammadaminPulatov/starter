# Project Index

Repozitoriya xaritasi. Yangi papka yoki modul qo'shsangiz, shu faylni yangilang.

## Kirish nuqtalari

| Savol | Fayl |
| --- | --- |
| Loyiha nima qiladi? | `docs/00-overview.md` |
| Nima qurilishi kerak? | `docs/01-requirements.md` |
| Qismlar qanday bog'langan? | `docs/02-architecture.md` |
| Qanday boshlayman? | `docs/guides/01-getting-started.md` |
| Qanday ishlayman? | `docs/guides/02-development-workflow.md` |
| Nima ishlamayapti? | `docs/guides/04-troubleshooting.md` |
| Production yonyapti | `docs/operations/runbook.md` |
| Agent qoidalari | `AGENTS.md` |

## Papkalar

### `apps/` — foydalanuvchi ko'radigan ilovalar

| Papka | Nima uchun | Holat |
| --- | --- | --- |
| `apps/web` | Sayt, admin panel, dashboard | bo'sh |
| `apps/mobile` | iOS/Android ilova | bo'sh |
| `apps/bot` | Telegram / Discord / Slack bot | bo'sh |

### `services/` — API va fon jarayonlari

| Papka | Nima uchun | Holat |
| --- | --- | --- |
| `services/api-node` | Node.js/TypeScript API | bo'sh |
| `services/api-python` | Python FastAPI API | bo'sh |
| `services/worker` | Navbat, cron, fon vazifalari | bo'sh |

### `packages/` — qayta ishlatiladigan umumiy kod

| Papka | Nima uchun | Holat |
| --- | --- | --- |
| `packages/ui` | Umumiy UI komponentlar | bo'sh |
| `packages/types` | Umumiy tip va sxemalar | bo'sh |
| `packages/sdk` | API mijoz kutubxonasi | bo'sh |
| `packages/config` | Umumiy lint/tsconfig/build konfiguratsiyasi | bo'sh |

### Qolganlari

| Papka | Nima uchun |
| --- | --- |
| `docs/` | Hujjatlar, qarorlar (ADR), qo'llanmalar, runbook |
| `infrastructure/` | Docker, nginx, terraform, monitoring, database konfiguratsiyasi |
| `design/` | Figma havolalari, brend, eksport qilingan assetlar |
| `scripts/` | `setup`, `run`, `doctor`, `init-project` avtomatika skriptlari |
| `.github/` | CI workflow, PR/issue shablonlari, dependabot |

## Muhim ildiz fayllar

| Fayl | Nima uchun |
| --- | --- |
| `Makefile` | Barcha kundalik buyruqlar (`make help`) |
| `docker-compose.yml` | Lokal infratuzilma (postgres, redis) |
| `.env.example` | Barcha environment o'zgaruvchilari ro'yxati |
| `scripts/run.sh` | Stackni aniqlab lint/test/build ishga tushiradi |
| `scripts/doctor.sh` | Repo sog'lig'ini tekshiradi (CI ham shuni chaqiradi) |

## Holat ustuni haqida

`bo'sh` — papkada faqat `README.md` bor. Ishlatmoqchi bo'lsangiz README'dagi init buyrug'ini bajaring va bu jadvalni yangilang. Ishlatmasangiz papkani o'chiring — hech narsa sinmaydi.

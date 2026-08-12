# Universal Project Template

Bu template web, mobile, bot, Python FastAPI va Node.js xizmatlarini bitta tartibli repozitoriyda yuritish uchun mo'ljallangan.

Barcha ilova va servis papkalari **ixtiyoriy**. Keraksizini o'chirsangiz, `make` buyruqlari va CI hamon ishlayveradi — avtomatika qaysi stack borligini o'zi aniqlaydi.

## Tez boshlash

GitHub'dagi **"Use this template"** tugmasidan yangi repozitoriya yarating (yoki `git clone` qiling), so'ng:

```bash
./scripts/init-project.sh   # loyiha nomi, kerakli stacklar, .env, git init
make setup                  # dependencylarni o'rnatadi
make dev                    # lokal infratuzilmani ko'taradi
make doctor                 # hamma narsa joyidami — tekshiradi
```

`make help` — barcha mavjud buyruqlar ro'yxati.

Keyingi qadam: loyihaning maqsadini `docs/00-overview.md` ga yozing.

## Asosiy qoidalar

- `apps/` — foydalanuvchi ko'radigan ilovalar.
- `services/` — API, fon jarayonlari va biznes logikasi.
- `packages/` — qayta ishlatiladigan umumiy kod.
- `docs/` — kelishilgan hujjatlar va qarorlar.
- Haqiqiy `.env`, token, parol va kalitlar Git ga qo'shilmaydi.
- Har o'zgarish lint, test va build tekshiruvlaridan o'tadi.

## Qaysi papkalarni qoldirish kerak

| Agar kerak bo'lsa | Papka |
| --- | --- |
| Sayt yoki admin panel | `apps/web` |
| Mobil ilova | `apps/mobile` |
| Telegram/Discord bot | `apps/bot` |
| Python API | `services/api-python` |
| Node.js API | `services/api-node` |
| Background worker | `services/worker` |

Har bir papka ichida `README.md` bor — u yerda nima kelishi va qanday boshlash yozilgan.

## Navigatsiya

| Savol | Fayl |
| --- | --- |
| Nima qayerda? | [`PROJECT_INDEX.md`](PROJECT_INDEX.md) |
| Qanday boshlayman? | [`docs/guides/01-getting-started.md`](docs/guides/01-getting-started.md) |
| Kundalik ish tartibi | [`docs/guides/02-development-workflow.md`](docs/guides/02-development-workflow.md) |
| Nima ishlamayapti? | [`docs/guides/04-troubleshooting.md`](docs/guides/04-troubleshooting.md) |
| Production muammosi | [`docs/operations/runbook.md`](docs/operations/runbook.md) |
| AI agent qoidalari | [`AGENTS.md`](AGENTS.md) |

API hujjati FastAPI uchun avtomatik `/docs` da, boshqa servislar uchun esa [`docs/api/openapi.yaml`](docs/api/openapi.yaml) faylida yuritiladi.

## Litsenziya

MIT — [`LICENSE`](LICENSE). O'z loyihangizga mos kelmasa, almashtiring.

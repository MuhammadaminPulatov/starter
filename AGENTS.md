# Agent qoidalari

Bu fayl — AI agentlar (Claude Code, Codex, Cursor va boshqalar) va yangi dasturchilar uchun majburiy kontrakt.
`CLAUDE.md` shu faylga havola qiladi, shuning uchun qoidalarni faqat shu yerda tahrirlang.

## Kod yozishdan oldin

1. `PROJECT_INDEX.md` ni o'qing — qaysi papka nima uchun ekanini biling.
2. Vazifaga tegishli hujjatni o'qing: `docs/01-requirements.md`, `docs/02-architecture.md` va agar mavjud bo'lsa `docs/modules/<modul>.md`.
3. Mavjud kodni qidiring. Yangi utilita yozishdan oldin `packages/` ichida shunga o'xshash narsa bor-yo'qligini tekshiring.

## Kod yozishda

- Mavjud uslub, nomlash va arxitekturani saqlang. Yangi pattern kiritmang — atrofdagi kodga o'xshating.
- Kodni to'g'ri joyga qo'ying: foydalanuvchi ko'radigan ilova → `apps/`, biznes logika va API → `services/`, qayta ishlatiladigan kod → `packages/`.
- Har o'zgarish bilan mos testni qo'shing yoki yangilang.
- **Secret, token, parol yoki API kalitini kodga, testga yoki logga yozmang.** Ular faqat `.env` da bo'ladi, `.env.example` ga esa faqat bo'sh placeholder qo'shiladi.
- Yangi environment o'zgaruvchisi qo'shsangiz, uni `.env.example` ga ham qo'shing — CI bu paritetni tekshiradi.

## Kod yozgandan keyin

Quyidagilar PR oldidan bajarilishi shart:

```bash
make lint
make test
make build
make doctor
```

Yangilanishi kerak bo'lgan hujjatlar:

| O'zgarish | Yangilanadigan fayl |
| --- | --- |
| Yangi papka yoki modul | `PROJECT_INDEX.md` |
| API endpoint | `docs/api/openapi.yaml` |
| Database sxemasi | `docs/04-database.md` + migration |
| Muhim texnik qaror | `docs/adr/` ichida yangi ADR |
| Foydalanuvchiga ta'sir qiladigan o'zgarish | `CHANGELOG.md` (`Unreleased` bo'limi) |

## Qilmaslik kerak

- Test yoki lint'ni "vaqtincha" o'chirib qo'yish.
- Xatoni yashirish uchun `try/except` yoki `catch {}` ni bo'sh qoldirish.
- Repozitoriyga `.env`, dump, backup yoki production ma'lumotini qo'shish.
- Bir PR ichida bir nechta bog'liq bo'lmagan o'zgarishni aralashtirish.
- So'ralmagan katta refactor qilish.

## Bu template haqida

Bu ko'p-stack starter. Barcha `apps/` va `services/` papkalari **ixtiyoriy**. Ishlatilmaydigani o'chirilsa, `make` buyruqlari va CI hamon ishlaydi — hamma avtomatika manifest fayliga qarab aniqlash (detection) asosida qurilgan. Shuning uchun avtomatikaga qattiq yo'l (hardcoded path) qo'shmang.

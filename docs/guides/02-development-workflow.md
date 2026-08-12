# Dasturlash tartibi

## Vazifani boshlash

1. Talabni [`docs/01-requirements.md`](../01-requirements.md) ichida tekshiring.
2. Tegishli modul hujjatini [`docs/modules/`](../modules/README.md) ichida o'qing yoki yarating.
3. Yangi branch yarating: `feature/short-name`.

## Kod yozish

1. Kodni tegishli `apps/`, `services/` yoki `packages/` ichiga joylashtiring.
2. Test qo'shing yoki yangilang.
3. API o'zgarsa [`docs/api/openapi.yaml`](../api/openapi.yaml) ni, DB o'zgarsa [`docs/04-database.md`](../04-database.md) ni yangilang.
4. Yangi environment o'zgaruvchisi qo'shsangiz, `.env.example` ga ham qo'shing.
5. Muhim qaror bo'lsa [`docs/adr/`](../adr/) ichida ADR yozing.

## Pull request oldidan

```bash
make lint && make test && make build && make doctor
```

- [ ] Lint bajarildi.
- [ ] Test bajarildi.
- [ ] Build bajarildi.
- [ ] `make doctor` toza.
- [ ] [`PROJECT_INDEX.md`](../../PROJECT_INDEX.md) kerak bo'lsa yangilandi.
- [ ] `CHANGELOG.md` dagi `Unreleased` yangilandi (foydalanuvchiga ta'sir qilsa).
- [ ] Hujjatlar yangilandi.

Batafsil qoidalar: [`CONTRIBUTING.md`](../../CONTRIBUTING.md) va [`AGENTS.md`](../../AGENTS.md).

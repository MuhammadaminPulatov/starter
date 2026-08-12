# Runbook

Production muammosi paytida ochiladigan fayl. Muhokama emas — harakat.

## 0. Birinchi 5 daqiqa

1. **Ta'sirni aniqlang:** kim, nima qila olmayapti, qachondan beri?
2. **O'zgarishni toping:** oxirgi deploy qachon bo'ldi? `git log --oneline -10`
3. **Xabar bering:** jamoaga qisqa xabar — "X ishlamayapti, tekshiryapman".
4. Agar oxirgi deploy sabab bo'lsa — tuzatishga urinmang, **rollback qiling** (3-bo'lim).

## 1. Health check

```bash
# Servislar holati
docker compose ps

# Loglardagi oxirgi xatolar
docker compose logs --tail=200 --since=15m

# Database ulanishi
docker compose exec postgres pg_isready -U "$POSTGRES_USER"
```

Tekshiriladigan tartib: **ilova → API → database → tashqi servislar**.

## 2. Keng tarqalgan hodisalar

| Alomat | Birinchi tekshiruv | Odatdagi sabab |
| --- | --- | --- |
| Barcha so'rovlar 5xx | Ilova logi, container holati | Yomon deploy, yetishmayotgan env o'zgaruvchi |
| So'rovlar sekin | Database connection pool, sekin query logi | Indeks yo'q, N+1 query |
| 401/403 to'lqini | Token muddati, kalit rotatsiyasi | Muddati o'tgan secret |
| Worker ish bajarmayapti | Navbat uzunligi, redis ulanishi | Worker o'lgan yoki broker uzilgan |
| Disk to'ldi | `df -h`, log hajmi | Log rotatsiyasi sozlanmagan |

## 3. Rollback

```bash
# 1. Oxirgi ishlagan versiyani toping
git log --oneline --decorate -20

# 2. O'sha versiyaga deploy qiling (platformaga qarab)
#    Tavsiya: yangi commit bilan revert, force push emas
git revert <bad-commit-sha>
```

**Migration bo'lgan bo'lsa:** avval migration'ni qaytarish mumkinligini tekshiring. Ma'lumot yo'qotadigan migration'ni qaytarmang — o'rniga oldinga tuzatuvchi migration yozing.

## 4. Backupdan tiklash

```bash
# Backup ro'yxati
ls -lh <backup-joylashuvi>

# Tiklashdan OLDIN joriy holatni saqlang
pg_dump "$DATABASE_URL" > before-restore-$(date +%F-%H%M).sql

# Tiklash
psql "$DATABASE_URL" < <backup-fayli>.sql
```

Tiklashdan keyin: migration versiyasini, asosiy jadval qatorlar sonini va bitta haqiqiy user flow'ni tekshiring.

## 5. Hodisadan keyin

Hodisa yopilgach `docs/adr/` yoki alohida incident faylida yozing:

- Nima bo'ldi va qancha davom etdi.
- Ildiz sabab (kimning aybi emas — qaysi jarayon yo'qligi).
- Qaytarilmasligi uchun qilinadigan aniq o'zgarish + kim va qachon qiladi.

## Aloqa

| Rol | Kim | Kanal |
| --- | --- | --- |
| Loyiha egasi | _to'ldiring_ | _to'ldiring_ |
| Deploy javobgari | _to'ldiring_ | _to'ldiring_ |
| Database javobgari | _to'ldiring_ | _to'ldiring_ |

# Deploy qo'llanmasi

Bu hujjat **qanday** qilish haqida. Muhitlar, siyosat va majburiy shartlar: [`docs/05-deployment.md`](../05-deployment.md).

## Staging

1. Pull request tekshiruvlari muvaffaqiyatli tugaganini tasdiqlang.
2. Kerakli migrationlarni tekshiring — qaytarilishi mumkinmi?
3. Yangi environment o'zgaruvchilari staging'ga qo'shilganini tasdiqlang.
4. Staging environmentga deploy qiling.
5. Muhim user flow va API endpointlarni sinang.
6. Loglarda yangi xato turlari paydo bo'lmaganini tekshiring.

## Production

1. `docs/05-deployment.md` dagi "Deploy oldidan majburiy shartlar" ro'yxatini to'liq bajaring.
2. Database backup mavjudligini va yangiligini tasdiqlang.
3. Production environment qiymatlarini tekshiring.
4. Deploy qiling.
5. Health check, log va monitoringni kamida 15 daqiqa kuzating.
6. Muammo bo'lsa — tuzatishga urinmang, [`docs/operations/runbook.md`](../operations/runbook.md) bo'yicha rollback qiling.

## Deploydan keyin

- `CHANGELOG.md` dagi `Unreleased` bo'limini versiyaga aylantiring.
- Jamoaga nima deploy qilinganini qisqa yozing.

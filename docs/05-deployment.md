# Deploy — muhitlar va siyosat

Bu hujjat **nima va nega** haqida. Qadamma-qadam ko'rsatma uchun: [`docs/guides/03-deployment-guide.md`](guides/03-deployment-guide.md).
Production yonayotgan bo'lsa: [`docs/operations/runbook.md`](operations/runbook.md).

## Muhitlar

| Muhit | Maqsad | Ma'lumot | Kim deploy qiladi |
| --- | --- | --- | --- |
| `development` | Lokal dasturlash | Soxta/seed ma'lumot | Har bir dasturchi, o'z mashinasida |
| `staging` | Production'ga o'xshash sinov | Anonimlashtirilgan nusxa | `main` ga merge avtomatik |
| `production` | Haqiqiy foydalanuvchilar | Haqiqiy ma'lumot | Faqat tasdiqdan keyin |

## Deploy siyosati

- Production'ga faqat `main` branch'dan deploy qilinadi.
- Har bir deploy avval staging'dan o'tadi.
- Ish kuni oxirida yoki dam olish kuni oldidan production deploy qilinmaydi.
- Har bir deploy qaytarilishi (rollback) mumkin bo'lishi shart.

## Deploy oldidan majburiy shartlar

- [ ] CI barcha tekshiruvlardan o'tgan.
- [ ] Migration qaytarilishi mumkin yoki ma'lumot yo'qotmaydi.
- [ ] Yangi environment o'zgaruvchilari maqsadli muhitga qo'shilgan.
- [ ] Database backup mavjud va yangi.
- [ ] Rollback rejasi ma'lum.

## Secretlar

Secretlar faqat deploy platformasining secret saqlash tizimida bo'ladi — repozitoriyda emas, CI logida emas.
`.env.example` da faqat kalit nomlari va bo'sh placeholder turadi.

## Migration qoidasi

Sxema o'zgarishi ikki bosqichda qilinadi (expand → contract): avval yangi ustun/jadval qo'shiladi va kod ikkalasini ham qo'llab-quvvatlaydi, keyingi deployda eskisi o'chiriladi. Shunda rollback ma'lumot yo'qotmaydi.

## Monitoring

Deploydan keyin kamida 15 daqiqa kuzatiladi: xato darajasi, javob vaqti, navbat uzunligi, resurs sarfi.

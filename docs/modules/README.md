# Modul hujjatlari

Har bir muhim modul (auth, payment, notification, search…) uchun bitta fayl: `docs/modules/<modul-nomi>.md`.

Modul ustida ishlashdan oldin shu faylni o'qing. Modul o'zgarsa — shu faylni yangilang.

## Qachon modul hujjati yoziladi

Yoziladi: bir nechta servisga tegadigan, tashqi integratsiyasi bor, yoki biznes qoidasi murakkab bo'lgan modul uchun.

Yozilmaydi: bitta fayllik yordamchi kod uchun — u yerda oddiy izoh yetarli.

## Shablon

```markdown
# <Modul nomi>

## Maqsad
Bu modul qanday muammoni yechadi. 2–3 gap.

## Kirish nuqtalari
| Fayl | Nima uchun |
| --- | --- |
| `services/api-node/src/...` | ... |

## Ma'lumot oqimi
Kim chaqiradi → nima bo'ladi → nima qaytadi. Tashqi servislar ham ko'rsatiladi.

## Ma'lumotlar
Tegishli jadvallar, asosiy maydonlar, muhim indekslar.

## Biznes qoidalari
- Qoida va uning sababi.

## Xatolar
| Holat | Javob | Nima qilinadi |
| --- | --- | --- |

## Environment
Kerak bo'ladigan `.env` o'zgaruvchilari.

## Test
Qaysi testlar bu modulni qoplaydi va ularni qanday ishga tushirish.

## Ma'lum cheklovlar
Hozircha yechilmagan narsalar.
```

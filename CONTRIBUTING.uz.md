# Hissa qoʻshish

[English](CONTRIBUTING.md) · **Oʻzbekcha** · [Русский](CONTRIBUTING.ru.md)

Yordamingiz uchun rahmat. Issue, pull request va tarjima tuzatishlari — hammasi
ochiq.

## Ish tartibi

1. Har vazifa uchun alohida branch: `feature/login`, `fix/payment-error`.
2. Commit formati: `feat: add login`, `fix: validate phone number`.
   Keng tarqalgan turlar: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `ci`.
3. Pull request kichik va bitta mavzuga tegishli boʻlsin.
4. PR ochishdan oldin tekshiruvlarni bajaring:

   ```bash
   make lint && make test && make build && make doctor
   ```

5. Muhim texnik qarorlarni `docs/adr/` ichida ADR sifatida yozing.

## CI nimani tekshiradi

| Job | Nimani tasdiqlaydi |
| --- | --- |
| `structure` | Hujjat havolalari, `.env.example` pariteti, secret gigienasi, YAML toʻgʻriligi |
| `node` | Faqat `package.json` mavjud boʻlsa ishlaydi: install, lint, test, build |
| `python` | Faqat `pyproject.toml` mavjud boʻlsa ishlaydi: install, lint, test |
| `ci-ok` | Yuqoridagilarni yigʻadi — branch protection uchun aynan shuni "required" qiling |

Tegishli stack yoʻq boʻlsa `node`/`python` jobining oʻtkazib yuborilishi normal
holat, xato emas.

## Yangi til qoʻshish

Skript xabarlari `scripts/lang/` ichida. Qoʻshish tartibi:

1. `scripts/lang/en.sh` dan `scripts/lang/<kod>.sh` nusxasini oling.
2. Qiymatlarni tarjima qiling. **Barcha kalitlar** saqlanishi va **`%s`
   oʻrin egallovchilarining soni hamda tartibi bir xil** boʻlishi shart — bular
   printf format satrlari.
3. Sinang: `STARTER_LANG=<kod> make doctor` va `STARTER_LANG=<kod> make lint`.
4. Tilni `README*.md` va `scripts/README.md` dagi `STARTER_LANG` roʻyxatlariga
   qoʻshing.

Kalit paritetini tekshirish oson:

```bash
diff <(grep -o '^T_[A-Z_]*' scripts/lang/en.sh | sort) \
     <(grep -o '^T_[A-Z_]*' scripts/lang/<kod>.sh | sort)
```

> Eslatma: bash'da bitta qoʻshtirnoq ichida `'` belgisini escape qilib
> boʻlmaydi. Tilingizda apostrof kerak boʻlsa, toʻgʻri Unicode harflarni
> ishlating — oʻzbekcha katalogda `oʻ`, `gʻ` (U+02BB) va `ʼ` (U+02BC).

## Skriptlarni oʻzgartirish

- Foydalanuvchi koʻradigan barcha matn xabar katalogidan olinadi — kodga
  yozilgan satr boʻlmasin.
- **bash 3.2** bilan mos boʻlsin (macOS'dagi sukut boʻyicha versiya):
  associative array va `mapfile` ishlatilmaydi.
- Aniq bir app yoki servisga qattiq yoʻl yozmang. Avtomatika aniqlashga
  asoslangan — shuning uchun istalgan papkani oʻchirish mumkin.
- `doctor.sh` tekshiruvlari muammoni *va* uni qanday tuzatishni koʻrsatsin.

## Hujjatlarni tarjima qilish

Maʼlumotnoma hujjatlari ingliz tilida yuritiladi. Uchta hujjat tarjima
qilinadi: `README`, `docs/guides/01-getting-started.md` va `CONTRIBUTING.md`.
Ulardan birini oʻzgartirsangiz, boshqa tildagi variantlarini ham yangilang yoki
PR'da ular yangilanishi kerakligini yozib qoʻying.

## Muammo haqida xabar berish

- Bug va yangi funksiya: issue shablonlaridan foydalaning.
- Xavfsizlik: ochiq issue **ochmang** — [SECURITY.md](SECURITY.md) ga qarang.

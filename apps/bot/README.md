# apps/bot

Telegram, Discord yoki Slack bot.

**Qanday boshlash**

```bash
mkdir -p apps/bot && cd apps/bot && npm init -y
npm i telegraf        # yoki: pip install aiogram
```

**Eslatma:** bot tokeni `.env` dagi `TELEGRAM_BOT_TOKEN` dan o'qiladi. Uzoq davom etadigan ishni botda emas, `services/worker` da bajaring.

**Ishlatmasangiz:** bu papkani o'chiring. `make` va CI hamon ishlaydi.

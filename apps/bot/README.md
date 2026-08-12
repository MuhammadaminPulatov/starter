# apps/bot

A Telegram, Discord or Slack bot.

**Getting started**

```bash
mkdir -p apps/bot && cd apps/bot && npm init -y
npm i telegraf        # or: pip install aiogram
```

**Note:** the bot token is read from `TELEGRAM_BOT_TOKEN` in `.env`. Long-running
work belongs in `services/worker`, not in the bot process.

**Not using it?** Delete this directory. `make` and CI keep working.

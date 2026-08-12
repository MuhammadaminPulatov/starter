# alembic

Database migrationlari.

```bash
alembic revision --autogenerate -m "add users table"
alembic upgrade head
alembic downgrade -1
```

**Qoida:** har bir migration qaytarilishi (`downgrade`) mumkin bo'lishi kerak. Ma'lumot yo'qotadigan o'zgarish ikki bosqichda qilinadi — `docs/05-deployment.md` ga qarang.

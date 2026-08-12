# alembic

Database migrations.

```bash
alembic revision --autogenerate -m "add users table"
alembic upgrade head
alembic downgrade -1
```

**Rule:** every migration must be reversible (`downgrade`). A change that loses
data goes through two phases — see `docs/05-deployment.md`.

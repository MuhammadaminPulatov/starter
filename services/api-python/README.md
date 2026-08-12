# services/api-python

Python FastAPI xizmati.

**Qanday boshlash**

```bash
cd services/api-python
uv init && uv add fastapi uvicorn sqlalchemy alembic
uv add --dev ruff pytest
```

`pyproject.toml` paydo bo'lgach `make lint/test` bu servisni avtomatik topadi (`ruff check`, `pytest`).

**Tuzilishi:** kod `app/`, migrationlar `alembic/`, testlar `tests/`.
FastAPI API hujjatini `/docs` da avtomatik chiqaradi.

**Ishlatmasangiz:** bu papkani o'chiring.

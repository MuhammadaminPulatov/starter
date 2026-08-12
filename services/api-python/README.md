# services/api-python

Python FastAPI xizmati.

**Qanday boshlash**

```bash
cd services/api-python
uv init && uv add fastapi uvicorn sqlalchemy alembic
uv add --dev ruff pytest
```

`pyproject.toml` paydo bo'lgach `make lint/test` bu servisni avtomatik topadi (`ruff check`, `pytest`).

**Muhim:** servis kutubxona emas, ilova. `pyproject.toml` ga quyidagilarni qo'shing, aks holda `uv sync` uni paket sifatida build qilishga urinadi va `app`/`alembic` papkalari tufayli xato beradi:

```toml
[tool.uv]
package = false

[tool.pytest.ini_options]
pythonpath = ["."]      # `from app.main import ...` ishlashi uchun
testpaths = ["tests"]
```

**Tuzilishi:** kod `app/`, migrationlar `alembic/`, testlar `tests/`.
FastAPI API hujjatini `/docs` da avtomatik chiqaradi.

**Ishlatmasangiz:** bu papkani o'chiring.

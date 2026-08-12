# services/api-python

The Python FastAPI service.

**Getting started**

```bash
cd services/api-python
uv init && uv add fastapi uvicorn sqlalchemy alembic
uv add --dev ruff pytest
```

Once `pyproject.toml` exists, `make lint/test` picks this service up
automatically (`ruff check`, `pytest`).

**Important:** this is an application, not a library. Add the following to
`pyproject.toml`, otherwise `uv sync` tries to build it as a package and fails
because of the `app` and `alembic` directories:

```toml
[tool.uv]
package = false

[tool.pytest.ini_options]
pythonpath = ["."]      # so that `from app.main import ...` works
testpaths = ["tests"]
```

**Layout:** code in `app/`, migrations in `alembic/`, tests in `tests/`.
FastAPI serves the API documentation at `/docs` automatically.

**Not using it?** Delete this directory.

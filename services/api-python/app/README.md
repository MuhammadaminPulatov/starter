# app

The FastAPI application. Suggested layout:

| File / directory | Purpose |
| --- | --- |
| `main.py` | The FastAPI app and router wiring |
| `api/` | Endpoints (APIRouter) |
| `models/` | SQLAlchemy models |
| `schemas/` | Pydantic schemas |
| `services/` | Business logic |
| `core/` | Config, security, dependencies |

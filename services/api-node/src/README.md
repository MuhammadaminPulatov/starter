# src

API source code. Suggested layout:

| Directory | Purpose |
| --- | --- |
| `routes/` | HTTP endpoints — request/response only, no business logic |
| `services/` | Business logic |
| `repositories/` | Database access |
| `middleware/` | Auth, logging, error handling |
| `config/` | Reading and validating the environment |

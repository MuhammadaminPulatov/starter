# Database

This document holds the ER diagram, the main tables, indexes, and the backup
and migration rules.

## Migration rules

- Every migration must be reversible, or must not lose data.
- Schema changes that drop or rename go through expand → contract: add the new
  shape first and support both, remove the old shape in a later deploy.
- Migrations live inside the owning service (for example
  `services/api-python/alembic/`), not in `infrastructure/`.

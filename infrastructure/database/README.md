# infrastructure/database

Database infrastructure: init SQL scripts, seed data, backup/restore scripts,
configuration files.

`docker-compose.yml` mounts this directory into
`/docker-entrypoint-initdb.d`, so any `*.sql` file here runs the first time the
database starts.

Migrations do not live here — they belong to the owning service (for example
`services/<service>/alembic/`).

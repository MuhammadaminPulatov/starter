# API conventions

- Every route is versioned: `/api/v1/...`
- Errors are returned in one consistent shape (see `docs/api/openapi.yaml`).
- Endpoints check authentication and permissions.
- The OpenAPI/Swagger document is kept up to date with the code.

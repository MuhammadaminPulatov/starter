# packages/types

Types and validation schemas shared by the frontend, backend and bot.

**What belongs here:** domain types (`User`, `Order`), API request/response
shapes, enums, `zod`/`pydantic` schemas.

**Rule:** this package depends on nothing else — it is the bottom layer. When
an API shape changes, keep it in sync with `docs/api/openapi.yaml`.

**Not using it?** Delete this directory.

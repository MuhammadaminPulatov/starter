# services/api-node

The Node.js / TypeScript API.

**Getting started**

```bash
cd services/api-node && npm init -y
npm i fastify         # or express, nestjs, hono
npm pkg set scripts.lint="eslint ." scripts.test="vitest run" scripts.build="tsc"
```

Once `scripts.lint`, `scripts.test` and `scripts.build` exist, `make lint/test/build`
picks this service up automatically.

**Layout:** code in `src/`, tests in `tests/`. When the API changes, update
`docs/api/openapi.yaml`.

**Not using it?** Delete this directory.

# services/api-node

Node.js / TypeScript API.

**Qanday boshlash**

```bash
cd services/api-node && npm init -y
npm i fastify         # yoki express, nestjs, hono
npm pkg set scripts.lint="eslint ." scripts.test="vitest run" scripts.build="tsc"
```

`scripts.lint`, `scripts.test`, `scripts.build` qo'shilgach `make lint/test/build` bu servisni avtomatik topadi.

**Tuzilishi:** kod `src/`, testlar `tests/`. API o'zgarsa `docs/api/openapi.yaml` yangilanadi.

**Ishlatmasangiz:** bu papkani o'chiring.

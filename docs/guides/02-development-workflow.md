# Development workflow

## Starting a task

1. Check the requirement in [`docs/01-requirements.md`](../01-requirements.md).
2. Read or create the module document in [`docs/modules/`](../modules/README.md).
3. Create a branch: `feature/short-name`.

## Writing code

1. Put the code in the right place: `apps/`, `services/` or `packages/`.
2. Add or update a test.
3. If the API changes, update [`docs/api/openapi.yaml`](../api/openapi.yaml);
   if the database changes, update [`docs/04-database.md`](../04-database.md).
4. If you add an environment variable, add it to `.env.example` too.
5. If you make a significant decision, write an ADR in [`docs/adr/`](../adr/).

## Before opening a pull request

```bash
make lint && make test && make build && make doctor
```

- [ ] Lint passed.
- [ ] Tests passed.
- [ ] Build passed.
- [ ] `make doctor` is clean.
- [ ] [`PROJECT_INDEX.md`](../../PROJECT_INDEX.md) updated if needed.
- [ ] `CHANGELOG.md` updated if the change is user-visible.
- [ ] Documentation updated.

Full rules: [`CONTRIBUTING.md`](../../CONTRIBUTING.md) and
[`AGENTS.md`](../../AGENTS.md).

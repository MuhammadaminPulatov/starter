# packages/sdk

The API client library. Apps in `apps/` do not `fetch` the backend directly —
they call through this SDK.

**What it provides:** typed methods, auth headers, one consistent error shape,
retries.

Depending on `packages/types` is expected.

**Not using it?** Delete this directory.

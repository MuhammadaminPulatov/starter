# Deployment guide

This document covers **how**. For environments, policy and the required
pre-flight checks see [`docs/05-deployment.md`](../05-deployment.md).

## Staging

1. Confirm every pull request check passed.
2. Review the pending migrations — are they reversible?
3. Confirm new environment variables exist in staging.
4. Deploy to staging.
5. Exercise the important user flows and API endpoints.
6. Check the logs for new error types.

## Production

1. Complete the "Required before deploying" checklist in `docs/05-deployment.md`.
2. Confirm a recent database backup exists.
3. Verify the production environment values.
4. Deploy.
5. Watch health checks, logs and monitoring for at least 15 minutes.
6. If something is wrong, do not try to patch forward — roll back using
   [`docs/operations/runbook.md`](../operations/runbook.md).

## After deploying

- Turn the `Unreleased` section of `CHANGELOG.md` into a released version.
- Tell the team briefly what shipped.

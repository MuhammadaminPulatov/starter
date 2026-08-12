# Deployment — environments and policy

This document covers **what and why**. For the step-by-step procedure see
[`docs/guides/03-deployment-guide.md`](guides/03-deployment-guide.md).
If production is on fire: [`docs/operations/runbook.md`](operations/runbook.md).

## Environments

| Environment | Purpose | Data | Who deploys |
| --- | --- | --- | --- |
| `development` | Local development | Fake / seed data | Every developer, locally |
| `staging` | Production-like testing | Anonymised copy | Automatic on merge to `main` |
| `production` | Real users | Real data | Only after approval |

## Deployment policy

- Production is deployed from `main` only.
- Every deploy passes through staging first.
- No production deploy at the end of the day or right before a weekend.
- Every deploy must be reversible.

## Required before deploying

- [ ] All CI checks passed.
- [ ] Migrations are reversible or lose no data.
- [ ] New environment variables exist in the target environment.
- [ ] A recent database backup exists.
- [ ] The rollback plan is known.

## Secrets

Secrets live in the deployment platform's secret store — not in the repository
and not in CI logs. `.env.example` holds key names and empty placeholders only.

## Migration rule

Schema changes happen in two phases (expand → contract): first add the new
column or table while the code supports both shapes, then remove the old one in
a later deploy. That keeps rollback from losing data.

## Monitoring

Watch for at least 15 minutes after a deploy: error rate, response time, queue
depth, resource usage.

# Runbook

The file you open while production is broken. Not for discussion — for action.

## 0. First five minutes

1. **Scope the impact:** who cannot do what, and since when?
2. **Find the change:** when was the last deploy? `git log --oneline -10`
3. **Tell the team:** a short message — "X is broken, I'm looking".
4. If the last deploy caused it, do not patch forward — **roll back** (section 3).

## 1. Health check

```bash
# Service status
docker compose ps

# Recent errors
docker compose logs --tail=200 --since=15m

# Database connectivity
docker compose exec postgres pg_isready -U "$POSTGRES_USER"
```

Check in this order: **app → API → database → third-party services**.

## 2. Common incidents

| Symptom | First check | Usual cause |
| --- | --- | --- |
| All requests 5xx | App logs, container status | Bad deploy, missing env var |
| Requests are slow | Connection pool, slow query log | Missing index, N+1 query |
| Wave of 401/403 | Token expiry, key rotation | Expired secret |
| Worker not processing | Queue depth, redis connectivity | Worker died, broker disconnected |
| Disk full | `df -h`, log sizes | Log rotation not configured |

## 3. Rollback

```bash
# 1. Find the last good version
git log --oneline --decorate -20

# 2. Deploy it (depends on your platform)
#    Prefer a revert commit over a force push
git revert <bad-commit-sha>
```

**If a migration shipped:** check first whether it can be reversed. Do not
reverse a migration that loses data — write a forward fix instead.

## 4. Restore from backup

```bash
# List the backups
ls -lh <backup-location>

# Save the current state BEFORE restoring
pg_dump "$DATABASE_URL" > before-restore-$(date +%F-%H%M).sql

# Restore
psql "$DATABASE_URL" < <backup-file>.sql
```

After restoring, verify: migration version, row counts on key tables, and one
real user flow.

## 5. After the incident

Once it is closed, write it down in `docs/adr/` or a dedicated incident file:

- What happened and how long it lasted.
- The root cause — not who made the mistake, but which safeguard was missing.
- The concrete change that prevents a repeat, plus who does it and when.

## Contacts

| Role | Who | Channel |
| --- | --- | --- |
| Project owner | _fill in_ | _fill in_ |
| Deploy owner | _fill in_ | _fill in_ |
| Database owner | _fill in_ | _fill in_ |

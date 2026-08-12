# Security Policy

## Reporting a vulnerability

Do **not** open a public issue for a security problem. Use
[GitHub private security advisories](https://github.com/MuhammadaminPulatov/starter/security/advisories/new)
instead, or contact the project owner privately.

Please include: what the issue is, how to reproduce it, and the impact you
believe it has. You can expect an acknowledgement within a few days.

## Rules for this repository

- Never commit secrets, tokens, passwords, private keys or production data.
  Real values belong in `.env`, which is git-ignored.
- `.env.example` contains key names and empty placeholders only.
- `make doctor` runs a secret tripwire on every check, and CI runs it on every
  pull request.
- Secrets for deployed environments live in the deployment platform's secret
  store — never in the repository and never in CI logs.

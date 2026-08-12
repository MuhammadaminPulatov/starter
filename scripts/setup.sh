#!/usr/bin/env bash
#
# Prepares the project: creates .env and installs dependencies.
# Safe to run more than once (idempotent).

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

cd "$REPO_ROOT"

info "$T_SETUP_ENV_CHECK"
if [ -f .env ]; then
  ok "$T_SETUP_ENV_EXISTS"
else
  [ -f .env.example ] || die "$T_SETUP_NO_EXAMPLE"
  cp .env.example .env
  ok "$T_SETUP_ENV_CREATED"
  warn "$T_SETUP_FILL_SECRETS"
fi

echo
info "$T_SETUP_INSTALLING"
"$REPO_ROOT/scripts/run.sh" install

echo
info "$T_SETUP_NEXT"
printf '%s\n' "$T_SETUP_NEXT_DEV"
printf '%s\n' "$T_SETUP_NEXT_DOCTOR"
printf '%s\n' "$T_SETUP_NEXT_HELP"

#!/usr/bin/env bash
set -euo pipefail

for file in compose/*/docker-compose.yml; do
  echo "Validating ${file}"
  docker compose --env-file compose/.env.example -f "${file}" config >/dev/null
done

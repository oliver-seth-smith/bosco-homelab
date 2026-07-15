#!/usr/bin/env bash
set -euo pipefail

for file in compose/*/docker-compose.yml; do
  echo "Validating ${file}"
  docker compose -f "${file}" config >/dev/null
done


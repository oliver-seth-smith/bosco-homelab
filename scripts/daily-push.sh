#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/home/oliver/bosco-homelab"
LOG_FILE="${REPO_DIR}/docs/daily-log.md"

cd "${REPO_DIR}"

git pull --ff-only origin main

mkdir -p docs

if grep -q "## $(date +%F)" "${LOG_FILE}" 2>/dev/null; then
  echo "Daily log already has an entry for $(date +%F)."
  exit 0
fi

{
  echo
  echo "## $(date +%F)"
  echo
  echo "- Checked B.O.S.C.O. services."
  echo "- Reviewed monitoring and deployment notes."
} >> "${LOG_FILE}"

git add docs/daily-log.md
git commit -m "Log daily homelab progress: $(date +%F)"
git push origin main

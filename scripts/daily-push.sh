#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${BOSCO_REPO_DIR:-/srv/bosco/repo}"
LOG_FILE="${REPO_DIR}/docs/daily-log.md"
DATE="$(date +%F)"

cd "${REPO_DIR}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "${REPO_DIR} is not a Git working tree. Clone the repo on bosco before running this script." >&2
  exit 1
fi

git pull --ff-only origin main

mkdir -p docs

if grep -q "## ${DATE}" "${LOG_FILE}" 2>/dev/null; then
  echo "Daily log already has an entry for ${DATE}."
  exit 0
fi

{
  echo
  echo "## ${DATE}"
  echo
  echo "- Host: $(hostname)"
  echo "- Uptime: $(uptime -p 2>/dev/null || echo unavailable)"
  echo "- Disk: $(df -h /srv/bosco 2>/dev/null | awk 'NR==2 {print $5 \" used on \" $6}' || echo unavailable)"
  echo "- Docker containers: $(docker ps --format '{{.Names}}={{.Status}}' 2>/dev/null | paste -sd '; ' - || echo unavailable)"
  echo "- Backup timer: $(systemctl is-active bosco-backup.timer 2>/dev/null || echo unavailable)"
  echo "- Grafana health: $(curl -fsS http://localhost:3000/api/health 2>/dev/null | tr -d '\n' || echo unavailable)"
  echo "- Prometheus readiness: $(curl -fsS http://localhost:9090/-/ready 2>/dev/null || echo unavailable)"
  echo "- Loki readiness: $(curl -fsS http://localhost:3100/ready 2>/dev/null || echo unavailable)"
} >> "${LOG_FILE}"

git add docs/daily-log.md
git commit -m "Log daily homelab progress: ${DATE}"
git push origin main

#!/usr/bin/env bash
set -euo pipefail

: "${RESTIC_REPOSITORY:?RESTIC_REPOSITORY is required}"
: "${RESTIC_PASSWORD:?RESTIC_PASSWORD is required}"

restic backup /srv/bosco --tag bosco --exclude "**/cache"
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune


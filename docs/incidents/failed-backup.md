# Incident Runbook: Failed Backup

## Symptoms

- Backup job exits non-zero.
- Restic repository is unreachable.
- Monitoring reports stale backup age.

## Triage

```bash
systemctl status bosco-backup.timer
systemctl status bosco-backup.service
journalctl -u bosco-backup.service --since "24 hours ago"
restic snapshots
```

Check:

- Repository endpoint is reachable.
- Credentials are present.
- Enough free disk exists locally and remotely.
- The repository is not locked.

## Recovery

Unlock only after confirming no backup is actively running:

```bash
restic unlock
```

Run a manual backup:

```bash
./scripts/backup-restic-example.sh
```

## Follow-Up

- Document missed backup window.
- Confirm the next scheduled backup succeeds.
- Run a restore test if repository corruption was suspected.


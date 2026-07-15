# Incident Runbook: Disk Full

## Symptoms

- Alerts show disk above threshold.
- Containers fail to write data.
- Docker pulls or database writes fail.

## Triage

```bash
df -h
docker system df
sudo du -xh /srv/bosco --max-depth=2 | sort -h
sudo du -xh /var/lib/docker --max-depth=1 | sort -h
```

## Recovery

Prune only unused Docker resources:

```bash
docker system prune
```

Rotate or compress oversized logs:

```bash
journalctl --disk-usage
sudo journalctl --vacuum-time=14d
```

## Follow-Up

- Increase alert lead time if the disk filled too quickly.
- Add retention limits for logs and metrics.
- Move large media or backup data off the OS disk.


# Backup And Restore

## Backup Policy

| Data | Tool | Frequency | Retention | Restore target |
| --- | --- | --- | --- | --- |
| `/srv/bosco` | Restic | Daily | 7 daily, 4 weekly, 6 monthly | Temporary restore directory |
| Compose files | Git | Every change | Git history | Fresh clone |
| Terraform state | Remote backend or encrypted backup | Every change | Versioned | Recovery workstation |
| Proxmox VM snapshots | Proxmox backup or snapshot | Before major changes | Short-term | Proxmox host |

## Configure Restic

Install the systemd timer with Ansible:

```bash
ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/bootstrap.yml
```

Create `/etc/bosco/restic.env` on the server using [docs/examples/restic.env.example](/home/oliver/bosco-homelab/docs/examples/restic.env.example) as a template.

Run a manual backup through systemd:

```bash
sudo systemctl start bosco-backup.service
sudo systemctl status bosco-backup.service
```

## Restore Test Procedure

1. Pick a service volume under `/srv/bosco`.
2. Restore the latest snapshot to `/tmp/bosco-restore-test`.
3. Verify expected files and permissions.
4. Delete the temporary restore after documenting results.

Example:

```bash
restic snapshots --tag bosco
mkdir -p /tmp/bosco-restore-test
restic restore latest --target /tmp/bosco-restore-test --include /srv/bosco
find /tmp/bosco-restore-test/srv/bosco -maxdepth 2 -type f | head
```

## Restore Test Log

| Date | Snapshot | Data restored | Result | Notes |
| --- | --- | --- | --- | --- |
| TODO | TODO | TODO | TODO | TODO |

## Definition Of Done

- Backups run automatically.
- Failed backup alerts are visible in monitoring.
- A restore test has been completed and documented.
- Restore docs are understandable without relying on memory.

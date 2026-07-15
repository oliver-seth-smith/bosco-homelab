# Deployment Log

## 2026-07-15: Initial Base OS Bootstrap

Target host:

- Hostname: `bosco`
- Platform: Proxmox VE 7.0.14-4 / Debian GNU/Linux
- SSH user: `oliver`
- Deployment path: `/srv/bosco/repo`

What was completed:

- Created a non-root `oliver` account on the server.
- Installed `sudo` and added `oliver` to the `sudo` group.
- Ran the Ansible bootstrap playbook from the control workstation.
- Installed baseline packages.
- Enabled unattended security updates.
- Created `/srv/bosco`.
- Installed Docker from Debian/Proxmox package repositories.
- Installed Docker Compose v2 as a Docker CLI plugin when the distro package was unavailable.
- Added `oliver` to the `docker` group.
- Disabled SSH password authentication.
- Disabled direct root SSH login.
- Installed Restic.
- Installed and enabled the `bosco-backup.timer` systemd timer.
- Created `/srv/bosco/repo` for repository deployment.
- Copied the repository to the server with `rsync`.

Issues found and fixed:

| Issue | Cause | Fix |
| --- | --- | --- |
| Ansible could not find roles | `ansible.cfg` was only under `ansible/` | Added top-level `ansible.cfg` |
| `bosco_data_root` undefined | Group vars were outside the selected inventory tree | Moved group vars to `ansible/inventory/group_vars/bosco.yml` |
| `sudo: not found` | Fresh Proxmox/Debian install did not include sudo | Installed sudo as root and added `oliver` to sudo group |
| `docker-compose-v2` unavailable | Package does not exist in the target repositories | Install Docker Compose v2 CLI plugin from release asset |
| `rsync` permission denied to `/srv/bosco/repo` | `/srv/bosco` is root-owned | Create `/srv/bosco/repo` owned by `oliver` |

Current next step:

```bash
ssh oliver@192.168.68.69
cd /srv/bosco/repo
cp compose/.env.example compose/.env
docker compose --env-file compose/.env -f compose/monitoring/docker-compose.yml up -d
```


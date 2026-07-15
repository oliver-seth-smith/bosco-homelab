# Server-Hosted Daily Logging

The daily GitHub activity job should run on `bosco`, not on a personal workstation. That way the log reflects the homelab server as long as the server is online.

## What It Logs

[scripts/daily-push.sh](/home/oliver/bosco-homelab/scripts/daily-push.sh) appends one entry per day to `docs/daily-log.md` with:

- Hostname.
- Uptime.
- `/srv/bosco` disk usage.
- Running Docker container status.
- Backup timer state.
- Grafana health.
- Prometheus readiness.
- Loki readiness.

Then it commits and pushes the log to GitHub.

## Server Requirements

The server needs:

- `/srv/bosco/repo` as a real Git clone, not only an rsync copy.
- A GitHub deploy key or SSH key with push access to `oliver-seth-smith/bosco-homelab`.
- Git user identity configured on the server.
- Cron installed and running.

## One-Time Setup On Bosco

SSH into the server:

```bash
ssh oliver@192.168.68.69
```

If `/srv/bosco/repo` is currently an rsync copy without `.git`, replace it with a real clone:

```bash
cd /srv/bosco
mv repo repo.rsync-backup-$(date +%F-%H%M%S)
git clone git@github.com:oliver-seth-smith/bosco-homelab.git repo
cd repo
```

If the server does not have GitHub SSH access yet, create a key:

```bash
ssh-keygen -t ed25519 -C "bosco@homelab"
cat ~/.ssh/id_ed25519.pub
```

Add that public key to GitHub:

1. Open the GitHub repo.
2. Go to **Settings**.
3. Go to **Deploy keys**.
4. Add the key.
5. Enable **Allow write access**.

Then test:

```bash
ssh -T git@github.com
git pull --ff-only origin main
```

Set commit identity on the server:

```bash
git config user.name "Oliver Seth-Smith"
git config user.email "osethsmith@gmail.com"
```

## Install Server Cron

On `bosco`:

```bash
chmod +x /srv/bosco/repo/scripts/daily-push.sh
(crontab -l 2>/dev/null; echo "17 20 * * * /srv/bosco/repo/scripts/daily-push.sh >> /srv/bosco/daily-push.log 2>&1") | crontab -
```

Verify:

```bash
crontab -l
/srv/bosco/repo/scripts/daily-push.sh
tail -100 /srv/bosco/daily-push.log
```

## Disable Workstation Cron

On the workstation, remove the old local job:

```bash
crontab -e
```

Delete the line that runs:

```text
/home/oliver/bosco-homelab/scripts/daily-push.sh
```

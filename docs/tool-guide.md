# Tool Guide

This guide explains how to use the first B.O.S.C.O. tools after the base OS has been provisioned.

## Ansible

Purpose: configure the server repeatedly from code.

Run from the control workstation:

```bash
cd ~/bosco-homelab
ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/bootstrap.yml --ask-become-pass
```

Use it when:

- You change host configuration.
- You add system packages.
- You modify backup timers or hardening settings.
- You want to prove the server can be rebuilt from automation.

Useful checks:

```bash
ansible-inventory -i ansible/inventory/hosts.yml --host bosco-core
ansible-playbook --syntax-check -i ansible/inventory/hosts.yml ansible/playbooks/bootstrap.yml
```

## Docker Compose

Purpose: run application stacks.

On the server:

```bash
cd /srv/bosco/repo
docker compose --env-file compose/.env -f compose/monitoring/docker-compose.yml up -d
docker compose -f compose/monitoring/docker-compose.yml ps
docker compose -f compose/monitoring/docker-compose.yml logs --tail=100
```

Common commands:

```bash
docker compose -f compose/monitoring/docker-compose.yml pull
docker compose --env-file compose/.env -f compose/monitoring/docker-compose.yml up -d
docker compose -f compose/monitoring/docker-compose.yml restart grafana
docker compose -f compose/monitoring/docker-compose.yml down
```

Use `down` carefully because it stops the stack. Named volumes are preserved unless `--volumes` is added.

## Grafana

Purpose: dashboards for metrics and logs.

URL:

```text
http://192.168.68.69:3000
```

Initial login from the Compose file:

```text
admin / changeme
```

First actions:

1. Change the admin password.
2. Add Prometheus as a data source: `http://prometheus:9090`.
3. Add Loki as a data source: `http://loki:3100`.
4. Import a node_exporter dashboard.
5. Import or build a container dashboard using cAdvisor metrics.

Useful dashboard targets:

- CPU, memory, disk, and network for the host.
- Container CPU and memory.
- Container restarts.
- Disk usage for `/srv/bosco`.
- HTTP status and latency from Traefik after the edge stack is deployed.

## Prometheus

Purpose: scrape and store metrics.

URL:

```text
http://192.168.68.69:9090
```

Useful pages:

- `Status > Targets`: confirms scrape health.
- `Graph`: test PromQL queries.
- `Alerts`: shows alert rule state after rules are added.

Starter queries:

```promql
up
node_memory_MemAvailable_bytes
100 - (node_filesystem_avail_bytes{mountpoint="/"} * 100 / node_filesystem_size_bytes{mountpoint="/"})
rate(container_cpu_usage_seconds_total[5m])
```

## Loki

Purpose: central log storage for Grafana.

Loki does not need a browser UI. Use it through Grafana Explore after adding the Loki data source.

Starter LogQL queries:

```logql
{job="varlogs"}
{job="varlogs"} |= "error"
```

## Alertmanager

Purpose: route Prometheus alerts to notification channels.

URL:

```text
http://192.168.68.69:9093
```

The starter config has a placeholder receiver. Add email, Slack, Discord, ntfy, or another receiver when ready.

Use it to verify:

- Which alerts are firing.
- Whether alerts are grouped.
- Whether silences are active.

## Uptime Kuma

Purpose: black-box uptime checks.

URL:

```text
http://192.168.68.69:3002
```

Create monitors for:

- Grafana: `http://192.168.68.69:3000`
- Prometheus: `http://192.168.68.69:9090/-/ready`
- Alertmanager: `http://192.168.68.69:9093`
- Loki: `http://192.168.68.69:3100/ready`
- Authentik after deployment.
- Forgejo after deployment.

This is one of the easiest portfolio wins because it gives a clear service health page.

## Restic

Purpose: encrypted backups.

Ansible installs:

- `bosco-backup.service`
- `bosco-backup.timer`

Check timer state on the server:

```bash
systemctl list-timers bosco-backup.timer
systemctl status bosco-backup.timer
```

Before backups can run, create this file on the server:

```bash
sudo nano /etc/bosco/restic.env
```

Use [docs/examples/restic.env.example](/home/oliver/bosco-homelab/docs/examples/restic.env.example) as the template.

Run a manual backup:

```bash
sudo systemctl start bosco-backup.service
sudo journalctl -u bosco-backup.service -n 100 --no-pager
```

Run a restore test:

```bash
mkdir -p /tmp/bosco-restore-test
restic restore latest --target /tmp/bosco-restore-test --include /srv/bosco
```

## Authentik

Purpose: SSO for internal apps.

Deploy after monitoring is stable:

```bash
cd /srv/bosco/repo
docker compose --env-file compose/.env -f compose/security/docker-compose.yml up -d
```

URL:

```text
http://192.168.68.69:9000
```

Use it for:

- SSO to Grafana.
- SSO to Forgejo.
- MFA for admin users.
- Forward-auth protection for apps that do not support OIDC.

Before serious use, replace placeholder secrets in [compose/security/docker-compose.yml](/home/oliver/bosco-homelab/compose/security/docker-compose.yml).

## Forgejo

Purpose: internal Git hosting and developer platform practice.

Deploy:

```bash
cd /srv/bosco/repo
docker compose --env-file compose/.env -f compose/devops/docker-compose.yml up -d
```

URL:

```text
http://192.168.68.69:3001
```

Use it to demonstrate:

- Internal Git hosting.
- Repository permissions.
- SSO integration.
- CI runner integration later.

## Traefik

Purpose: reverse proxy and TLS termination.

Deploy only after DNS points to the server and ports 80/443 are routed correctly:

```bash
cd /srv/bosco/repo
docker compose --env-file compose/.env -f compose/edge/docker-compose.yml up -d
```

Use it for:

- Routing subdomains to internal apps.
- TLS certificate automation.
- Middleware such as redirects, headers, and auth forwarding.

## GitHub Actions

Purpose: prove changes are validated before deployment.

The workflow checks:

- Docker Compose config rendering.
- YAML linting.
- Ansible linting.
- Terraform formatting and validation.
- Secret scanning with Gitleaks.
- Configuration scanning with Trivy.

Use pull requests for meaningful changes so employers can see CI history.


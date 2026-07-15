# Monitoring Deployment

## Stack

- Prometheus for metrics collection.
- Grafana for dashboards.
- Loki for logs.
- Promtail for log shipping.
- node_exporter for host metrics.
- cAdvisor for container metrics.
- Uptime Kuma for black-box uptime checks.

## Deploy

```bash
cp compose/.env.example compose/.env
docker compose --env-file compose/.env -f compose/monitoring/docker-compose.yml up -d
```

## Initial Checks

```bash
docker compose -f compose/monitoring/docker-compose.yml ps
curl -fsS http://localhost:9090/-/ready
curl -fsS http://localhost:3000/api/health
curl -fsS http://localhost:3100/ready
```

## Dashboard Screenshots

Store screenshots here:

```text
docs/screenshots/grafana-node-exporter.png
docs/screenshots/grafana-containers.png
docs/screenshots/uptime-kuma-status.png
```

Minimum screenshots for the portfolio:

- Node exporter dashboard showing CPU, memory, disk, and network.
- Container dashboard showing running workloads and resource use.
- Uptime Kuma page showing checks for Grafana, Authentik, Forgejo, and Traefik.

## Alerting Targets

Create alerts for:

- Host disk usage above 85%.
- Host memory pressure.
- Container restarts.
- Endpoint unavailable for more than 5 minutes.
- Backup job missing or failed.
- TLS certificate expiring within 14 days.


# Application Recommendations

This list prioritizes services that demonstrate DevOps ability. A homelab can become a pile of apps quickly; keep the first phase focused on operational maturity.

## Must-Have

| App | Category | Recommended deployment | Notes |
| --- | --- | --- | --- |
| Traefik | Edge proxy | Docker Compose or k3s ingress | Use labels, middleware, TLS, and dashboard access controls. |
| Pi-hole | DNS | LXC or Compose | Pair with Unbound and document DNS forwarding. |
| Authentik | Identity | Compose first | Use OIDC for Grafana, Forgejo, and dashboards. |
| Prometheus | Metrics | Compose or Helm | Scrape node_exporter, cAdvisor, Traefik, and app metrics. |
| Grafana | Dashboards | Compose or Helm | Build dashboards for host, containers, and network. |
| Alertmanager | Alerting | Compose or Helm | Send alerts to email, Discord, Slack, or ntfy. |
| Loki | Logs | Compose or Helm | Centralize service logs. |
| Uptime Kuma | Availability | Compose | Create checks for every service and public dependency. |
| Restic | Backups | Systemd timer | Back up configs, volumes, and critical data. |
| Renovate | Dependency automation | GitHub app or container | Create PRs for image and dependency updates. |

## Strong Portfolio Additions

| App | Category | Why it helps |
| --- | --- | --- |
| Forgejo or Gitea | Internal Git | Shows developer platform thinking. |
| Woodpecker CI or Drone | CI/CD | Demonstrates runners, pipelines, secrets, and deployments. |
| SOPS with age | Secrets | Keeps encrypted secrets in Git safely. |
| Vault | Secrets | Good advanced topic after the baseline is mature. |
| Trivy | Security | Container and filesystem scanning. |
| Gitleaks | Security | Secret scanning in CI. |
| Checkov | Security | Terraform and IaC policy scanning. |
| Netdata | Monitoring | Fast host-level visibility. |
| ntfy | Notifications | Lightweight alert delivery. |
| Tailscale or WireGuard | Remote access | Safer than exposing admin panels publicly. |

## Personal Utility Apps

These are useful, but keep them secondary in the README so the repo still reads like a DevOps project.

- Vaultwarden
- Nextcloud
- Syncthing
- Paperless-ngx
- Home Assistant
- Jellyfin
- Immich
- Actual Budget

## Avoid As First Impressions

- Exposing many apps directly to the internet.
- Running everything as `latest`.
- Publishing `.env` files with real domains, passwords, or API keys.
- Having dashboards without alerts.
- Having backups without a documented restore test.
- Adding Kubernetes before the basic server is observable and recoverable.


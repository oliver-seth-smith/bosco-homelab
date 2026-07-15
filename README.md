# B.O.S.C.O. Homelab

B.O.S.C.O. stands for **Baseline Operations, Services, Compute, and Observability**. This repository documents and automates a personal homelab built to demonstrate practical DevOps skills: infrastructure as code, Linux administration, container orchestration, GitOps, monitoring, secrets management, backups, and incident response.

## Portfolio Goal

This lab is designed to be shown to potential employers as a working operations platform, not just a list of self-hosted apps.

The strongest signals this repo should show:

- Reproducible infrastructure with Terraform and Ansible.
- Containerized applications behind a reverse proxy with TLS.
- Metrics, logs, dashboards, uptime checks, and alerting.
- Git-based deployment workflow with CI validation.
- Documented backup and restore procedures.
- Security baseline: SSO, least privilege, secrets hygiene, patching, and network segmentation.
- Runbooks that explain how to operate and troubleshoot the environment.

## Recommended Core Stack

| Area | Recommendation | Why it matters for DevOps |
| --- | --- | --- |
| Virtualization | Proxmox VE | Shows VM/LXC management, storage, networking, snapshots, and cluster concepts. |
| Container runtime | Docker Compose first, then k3s | Compose is simple and reliable; k3s adds Kubernetes/GitOps experience. |
| Edge proxy | Traefik or Caddy | Demonstrates routing, TLS automation, middleware, and service discovery. |
| DNS | Pi-hole plus Unbound | Shows local DNS control, recursive DNS, and network services. |
| Identity | Authentik | Shows SSO, OIDC/SAML concepts, app access control, and MFA. |
| Monitoring | Prometheus, Grafana, Alertmanager | Core SRE/DevOps observability skills. |
| Logs | Loki plus Promtail | Centralized logs without heavyweight Elasticsearch operations. |
| Uptime | Uptime Kuma | Simple service availability checks and public status style dashboards. |
| Secrets | SOPS with age, plus optional Vault | Git-safe encrypted secrets and an upgrade path to dynamic secrets. |
| CI/CD | GitHub Actions plus Renovate | Shows automated validation and dependency maintenance. |
| Git hosting | Forgejo or Gitea | Demonstrates internal developer platform concepts. |
| Backups | Restic to NAS/S3-compatible storage | Proves restore thinking, not just backup creation. |
| Security scanning | Trivy, Checkov, Gitleaks | Shows supply chain, IaC, and secret scanning awareness. |

## Application Tiers

### Tier 0: Foundation

Run these first. They make the rest of the lab operable.

- Proxmox VE
- VLAN-aware network with a management subnet and service subnet
- Local DNS with Pi-hole
- Reverse proxy with TLS
- SSH keys and hardened Linux baseline
- Backups with restore tests

### Tier 1: Employer-Impressive Services

These are the services that best map to DevOps job responsibilities.

- Grafana, Prometheus, Alertmanager, Loki
- Authentik SSO
- Forgejo or Gitea
- Drone, Woodpecker CI, or GitHub Actions runners
- Renovate
- Uptime Kuma
- Netdata or node_exporter
- Trivy, Gitleaks, Checkov in CI

### Tier 2: Useful Homelab Apps

These make the lab personally useful while still providing operational practice.

- Vaultwarden
- Nextcloud or Syncthing
- Paperless-ngx
- Home Assistant
- Jellyfin
- Immich
- Actual Budget

### Tier 3: Advanced DevOps Proof

Add these once the core lab is stable.

- k3s cluster with Argo CD or Flux
- External Secrets Operator
- cert-manager
- Longhorn or democratic-csi
- OpenTelemetry collector
- Tailscale or WireGuard remote access
- Wazuh or CrowdSec for security monitoring
- Chaos testing and restore drills

## Repository Layout

```text
.
├── ansible/              # Host configuration and bootstrap automation
├── compose/              # Docker Compose stacks grouped by function
├── docs/                 # Architecture, runbooks, app recommendations
├── helm/                 # Future Kubernetes app definitions
├── scripts/              # Local helper scripts
├── terraform/            # Infrastructure provisioning
└── .github/workflows/    # CI checks for repo quality
```

## Quick Start

1. Copy environment examples:

   ```bash
   cp compose/.env.example compose/.env
   ```

2. Edit `compose/.env` for your domain, timezone, and paths.

3. Start the starter monitoring stack:

   ```bash
   docker compose --env-file compose/.env -f compose/monitoring/docker-compose.yml up -d
   ```

4. Start the edge stack after DNS is ready:

   ```bash
   docker compose --env-file compose/.env -f compose/edge/docker-compose.yml up -d
   ```

## Suggested Milestones

1. **Document the physical server**: CPU, RAM, disks, NICs, switch, VLANs, and network diagram.
2. **Provision the base OS** with Ansible.
3. **Deploy monitoring** and create screenshots of dashboards.
4. **Deploy SSO** and put internal apps behind it.
5. **Automate backups** and document a successful restore.
6. **Add CI checks** for Compose, Ansible, Terraform, and secret scanning.
7. **Write incident runbooks** for service outage, disk-full, expired cert, and failed backup.
8. **Move selected workloads to k3s** using GitOps.

## What To Show Employers

- A diagram of the network and service architecture.
- A dashboard screenshot showing live metrics.
- A pull request where CI catches a real issue.
- A runbook with a tested recovery command.
- A restore test log proving backups work.
- An explanation of why each service exists and how it is secured.


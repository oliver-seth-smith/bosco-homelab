# B.O.S.C.O. Homelab

B.O.S.C.O. stands for **Bunch Of Stuff Courtesy of, Oliver**. This repository documents and automates a personal homelab built to demonstrate practical DevOps skills: infrastructure as code, Linux administration, container orchestration, GitOps, monitoring, secrets management, backups, and incident response.

## Portfolio Goal

This lab is designed to be shown to potential employers as a working operations platform, not just a list of self-hosted apps.

The strongest signals this repo shows:

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

1. Provision the base OS with Ansible:

   ```bash
   ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/bootstrap.yml --ask-pass --ask-become-pass
   ```

2. Copy the repo to the server:

   ```bash
   rsync -av --exclude .git ./ oliver@192.168.68.69:/srv/bosco/repo/
   ```

3. Start the starter monitoring stack on the server:

   ```bash
   cd /srv/bosco/repo
   cp compose/.env.example compose/.env
   docker compose --env-file compose/.env -f compose/monitoring/docker-compose.yml up -d
   ```

4. Start the edge stack after DNS is ready:

   ```bash
   docker compose --env-file compose/.env -f compose/edge/docker-compose.yml up -d
   ```

For day-to-day usage, see [docs/tool-guide.md](/home/oliver/bosco-homelab/docs/tool-guide.md). For the actual first deployment notes, see [docs/deployment-log.md](/home/oliver/bosco-homelab/docs/deployment-log.md).

Daily operations logging is designed to run on `bosco` itself. See [docs/server-logging.md](/home/oliver/bosco-homelab/docs/server-logging.md).

## Suggested Milestones

1. **Document the physical server**: [docs/server-inventory.md](/home/oliver/bosco-homelab/docs/server-inventory.md)
2. **Provision the base OS** with Ansible: [docs/base-os.md](/home/oliver/bosco-homelab/docs/base-os.md)
3. **Deploy monitoring** and create screenshots: [docs/monitoring.md](/home/oliver/bosco-homelab/docs/monitoring.md)
4. **Deploy SSO** and put internal apps behind it: [docs/sso.md](/home/oliver/bosco-homelab/docs/sso.md)
5. **Automate backups** and document restore tests: [docs/backup-restore.md](/home/oliver/bosco-homelab/docs/backup-restore.md)
6. **Add CI checks** for Compose, Ansible, Terraform, and secret scanning: [.github/workflows/ci.yml](/home/oliver/bosco-homelab/.github/workflows/ci.yml)
7. **Write incident runbooks**: [docs/incidents](/home/oliver/bosco-homelab/docs/incidents)
8. **Move selected workloads to k3s** using GitOps: [docs/gitops-k3s.md](/home/oliver/bosco-homelab/docs/gitops-k3s.md)

## What To Show Employers

- A diagram of the network and service architecture.
- A dashboard screenshot showing live metrics.
- A pull request where CI catches a real issue.
- A runbook with a tested recovery command.
- A restore test log proving backups work.
- An explanation of why each service exists and how it is secured.

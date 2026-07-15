# k3s GitOps Migration Plan

## Goal

Move selected workloads from Docker Compose to k3s only after monitoring, backups, and SSO are stable.

## Recommended Cluster

| Node | Role | CPU | RAM | Notes |
| --- | --- | ---: | ---: | --- |
| `k3s-01` | server | 2 vCPU | 4 GiB | Control plane |
| `k3s-02` | agent | 2 vCPU | 4 GiB | Worker |
| `k3s-03` | agent | 2 vCPU | 4 GiB | Worker |

## GitOps Tooling

- Argo CD for pull-based deployment.
- Helm charts for packaged applications.
- SOPS with age for encrypted Kubernetes secrets.
- cert-manager for TLS.
- External Secrets Operator later if Vault is adopted.

## Migration Order

1. Deploy k3s cluster and confirm node health.
2. Install Argo CD.
3. Deploy a low-risk stateless app.
4. Move monitoring components that are easy to rebuild.
5. Move edge ingress only after DNS and TLS are tested.
6. Move stateful apps after storage and restore tests are proven.

## Do Not Move First

- Authentik database.
- Primary Git service.
- Password manager.
- Any app without a tested restore path.

## Acceptance Criteria

- Cluster is managed by Git, not kubectl snowflakes.
- A pull request changes a deployed app.
- Argo CD shows the app synced and healthy.
- Secrets are encrypted before commit.
- Monitoring can see node, pod, and ingress metrics.


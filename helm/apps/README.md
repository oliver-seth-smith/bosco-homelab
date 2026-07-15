# Kubernetes Apps

Use this directory when moving selected workloads from Docker Compose to k3s.

Recommended order:

1. Install k3s on three small VMs.
2. Install Argo CD or Flux.
3. Add cert-manager and external-dns if your DNS provider supports automation.
4. Move stateless services first.
5. Move stateful services only after storage, backups, and restore tests are proven.


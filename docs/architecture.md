# Architecture

## Target Design

```text
Internet
   |
Router / Firewall
   |
Managed switch
   |
Proxmox host
   |
   +-- Management VM/LXC
   |   +-- Ansible control
   |   +-- Monitoring access
   |
   +-- Edge VM/LXC
   |   +-- Traefik or Caddy
   |   +-- Authentik proxy integration
   |
   +-- Services VM
   |   +-- Docker Compose workloads
   |
   +-- Future k3s nodes
       +-- GitOps-managed workloads
```

## Network Segments

| Segment | Purpose | Example CIDR |
| --- | --- | --- |
| Management | Proxmox, SSH, admin interfaces | `10.10.10.0/24` |
| Services | Internal web apps and APIs | `10.10.20.0/24` |
| IoT | Untrusted smart devices | `10.10.30.0/24` |
| Guests | Guest Wi-Fi | `10.10.40.0/24` |

## Security Principles

- Admin interfaces are reachable only from the management network or VPN.
- Public exposure goes through the edge proxy only.
- Every service has an owner, backup policy, and health check.
- Secrets are stored in `.env` locally or encrypted with SOPS, never committed in plain text.
- Firewall rules deny by default between VLANs.

## Operational Principles

- All important configuration is committed to Git.
- Manual changes are either removed or documented as break-glass procedures.
- Backups are tested on a schedule.
- Alerts should be actionable and tied to runbooks.


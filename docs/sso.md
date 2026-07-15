# SSO Deployment

## Stack

- Authentik as the identity provider.
- OIDC for Grafana, Forgejo, and future internal services.
- MFA required for administrative users.
- Reverse proxy middleware for apps that do not support OIDC natively.

## Deploy

```bash
docker compose --env-file compose/.env -f compose/security/docker-compose.yml up -d
```

## First Configuration

1. Replace placeholder Authentik secrets before production use.
2. Create an admin account.
3. Enable MFA for the admin account.
4. Create an `homelab-admins` group.
5. Create OIDC providers for Grafana and Forgejo.
6. Restrict admin dashboards to `homelab-admins`.

## Apps To Put Behind SSO

| App | Method | Priority |
| --- | --- | --- |
| Grafana | Native OIDC | High |
| Forgejo | Native OIDC | High |
| Traefik dashboard | Forward auth or network-only access | High |
| Uptime Kuma | Native auth plus reverse proxy protection | Medium |
| Jellyfin | Native auth, optional proxy policy | Low |

## Acceptance Criteria

- Admin apps are not reachable anonymously.
- At least two apps use Authentik OIDC.
- MFA is enabled for the primary admin account.
- Break-glass local admin credentials are stored offline.


# Incident Runbook: Expired TLS Certificate

## Symptoms

- Browser reports expired certificate.
- Uptime checks fail with TLS errors.
- Traefik logs show ACME renewal failures.

## Triage

```bash
openssl s_client -connect example.homelab.example.com:443 -servername example.homelab.example.com </dev/null 2>/dev/null | openssl x509 -noout -dates
docker compose -f compose/edge/docker-compose.yml logs --tail=300 traefik
```

Check:

- DNS points to the edge proxy.
- Ports 80 and 443 reach Traefik.
- ACME email is correct.
- Rate limits were not exceeded.

## Recovery

```bash
docker compose --env-file compose/.env -f compose/edge/docker-compose.yml up -d
```

If renewal still fails, temporarily move the service to internal-only access and resolve DNS/firewall issues before retrying.

## Follow-Up

- Add a certificate-expiry alert.
- Document the root cause.
- Confirm the replacement certificate date.


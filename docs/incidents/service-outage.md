# Incident Runbook: Service Outage

## Symptoms

- Uptime Kuma reports endpoint down.
- User receives 502, 503, timeout, or DNS failure.
- Grafana panel shows missing metrics or repeated restarts.

## Triage

```bash
docker ps
docker compose -f compose/<stack>/docker-compose.yml ps
docker compose -f compose/<stack>/docker-compose.yml logs --tail=200 <service>
```

Check proxy routing:

```bash
docker compose -f compose/edge/docker-compose.yml logs --tail=200 traefik
```

## Recovery

Restart only the affected service first:

```bash
docker compose -f compose/<stack>/docker-compose.yml restart <service>
```

If the whole stack is unhealthy:

```bash
docker compose -f compose/<stack>/docker-compose.yml up -d
```

## Follow-Up

- Record start time, detection source, impact, root cause, and fix.
- Add or tune an alert if detection was manual.
- Add a health check if the app did not fail clearly.


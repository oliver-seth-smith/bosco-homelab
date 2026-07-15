# Runbooks

## Service Down

1. Check Uptime Kuma to confirm which endpoint is failing.
2. Check Traefik dashboard or logs for routing and TLS errors.
3. Check container state:

   ```bash
   docker ps
   docker compose -f compose/<stack>/docker-compose.yml ps
   ```

4. Inspect logs:

   ```bash
   docker compose -f compose/<stack>/docker-compose.yml logs --tail=200 <service>
   ```

5. Restart only the affected service:

   ```bash
   docker compose -f compose/<stack>/docker-compose.yml restart <service>
   ```

6. Write a short incident note in `docs/incidents/`.

## Disk Full

1. Check filesystem usage:

   ```bash
   df -h
   docker system df
   ```

2. Identify large directories:

   ```bash
   sudo du -xh /var/lib/docker --max-depth=1 | sort -h
   ```

3. Prune unused Docker resources only after confirming what will be removed:

   ```bash
   docker system prune
   ```

4. Add or tune alerts if this was not caught early.

## Backup Restore Test

1. Pick one low-risk service volume.
2. Restore it to a temporary directory.
3. Verify expected files exist.
4. Record date, command, result, and follow-up fixes.

Example log format:

```text
Date:
Service:
Backup source:
Restore target:
Result:
Issues found:
```

## Expired Certificate

1. Confirm DNS points to the edge proxy.
2. Check Traefik or Caddy certificate logs.
3. Verify ACME challenge method and firewall rules.
4. Renew or restart the edge proxy only after config validation.


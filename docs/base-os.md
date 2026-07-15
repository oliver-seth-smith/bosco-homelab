# Base OS Provisioning

Use Ansible to converge the host after the OS is installed and SSH access works.

## Goals

- Install baseline administration packages.
- Enable unattended security updates.
- Create the `/srv/bosco` application data root.
- Apply SSH hardening.
- Install Docker Engine package dependencies.
- Prepare the host for Compose-based services.

## First Run

1. Edit [ansible/inventory/hosts.yml](/home/oliver/bosco-homelab/ansible/inventory/hosts.yml) with the server IP and SSH user.
2. Confirm SSH key access:

   ```bash
   ssh oliver@10.10.10.10
   ```

3. Run the bootstrap playbook:

   ```bash
   ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/bootstrap.yml
   ```

## Post-Provision Checks

```bash
systemctl status unattended-upgrades
docker version
docker compose version
ls -ld /srv/bosco
sshd -T | grep -E 'passwordauthentication|permitrootlogin'
```

## Employer Talking Points

- The host is rebuilt from documented automation, not manual notes.
- Security updates are enabled by default.
- Application state is separated under `/srv/bosco`.
- SSH policy is explicit and reviewable.


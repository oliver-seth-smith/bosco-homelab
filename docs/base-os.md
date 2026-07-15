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
2. If this is a fresh Proxmox/Debian host and you can only log in as `root`, create the admin user first:

   ```bash
   ssh root@192.168.68.69
   apt update
   apt install -y sudo
   id oliver || adduser oliver
   usermod -aG sudo oliver
   exit
   ```

3. Confirm SSH access:

   ```bash
   ssh oliver@192.168.68.69
   ```

4. Run the bootstrap playbook:

   ```bash
   ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/bootstrap.yml --ask-pass --ask-become-pass
   ```

   If SSH keys are configured, `--ask-pass` is not needed.

5. Log out and back in after the playbook adds `oliver` to the `docker` group.

## Deploy Repository To Server

The playbook creates `/srv/bosco/repo` owned by `oliver`.

From the control workstation:

```bash
cd ~/bosco-homelab
rsync -av --exclude .git ./ oliver@192.168.68.69:/srv/bosco/repo/
```

## Post-Provision Checks

```bash
systemctl status unattended-upgrades
docker version
docker compose version
groups
ls -ld /srv/bosco /srv/bosco/repo
sshd -T | grep -E 'passwordauthentication|permitrootlogin'
```

## Employer Talking Points

- The host is rebuilt from documented automation, not manual notes.
- Security updates are enabled by default.
- Application state is separated under `/srv/bosco`.
- SSH policy is explicit and reviewable.

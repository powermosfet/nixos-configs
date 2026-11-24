# Kavita on zook

Kavita is served at https://bok.berge.id over Tailscale. nginx listens on
Wallabag's Tailscale address, currently `100.119.101.124:443`, and proxies to
`127.0.0.1:5000`. It shares zook's existing nginx address-wait dependency.
No additional firewall ports, Tailscale Serve, or Funnel are needed.

## Deployment

1. Create a Cloudflare **DNS-only** A record for `bok.berge.id` pointing to
   `100.119.101.124`. Do not add an AAAA record for this IPv4-only listener.
2. Reuse `/var/lib/acme/cloudflare.env` from Wallabag. Its token must allow
   zone read and DNS edit for `berge.id`; keep it root-owned with mode `0600`.
   DNS-01 validation does not require opening HTTP to the internet.
3. Before starting Kavita, generate its persistent signing key on zook:

   ```console
   sudo install -d -m 0700 -o root -g root /var/lib/kavita-secrets
   sudo sh -c 'set -eu; umask 077; set -C; head -c 64 /dev/urandom | base64 --wrap=0 > /var/lib/kavita-secrets/token-key'
   ```

   This refuses to overwrite an existing key. Keep the key out of Git and the
   Nix store. systemd supplies it to Kavita with `LoadCredential`.
4. Build and deploy through zook's usual host configuration. This repository
   exports modules, not `nixosConfigurations.zook`. Include the new files in
   the deployment; Git flakes omit untracked files.
5. Connect over Tailscale and create the initial administrator account. Configure
   libraries in Kavita using a directory readable by the `kavita` user. No book
   directory is imposed by this configuration. Use `https://bok.berge.id` as the
   external URL in Kavita's server settings. Tailnet policy must allow clients
   to reach zook on TCP 443.

The NixOS module manages its service user and state directory, which defaults
to `/var/lib/kavita`. The application port uses the module's default, `5000`.

## Verification

Check `systemctl status kavita nginx acme-bok.berge.id` and the corresponding
journals. Confirm the certificate is valid, a sample book scans and opens,
reading progress survives restart, and the service returns after reboot.
Check Wallabag and SilverBullet still work on their existing hostnames.

`ss -ltn` should show Kavita on `127.0.0.1:5000`. From a LAN device, use
`curl -kI --resolve bok.berge.id:443:ZOOK_LAN_IP https://bok.berge.id/`:
it must not serve Kavita. Also confirm a device without Tailscale cannot reach
the service from outside the LAN.

## Backups and recovery

Both existing Borg jobs include Kavita's state directory and
`/var/lib/kavita-secrets`. They stop `kavita.service` during backup and restart
it afterward so database writes are paused. Book libraries outside the state
directory need their own backup coverage. The existing gilli repository is unencrypted, so these
paths, including the signing key, inherit that backup policy.

Before upgrading, take a backup. A NixOS generation rollback does not undo
database migrations. To recover, stop Kavita, preserve current state, restore
the state and signing key with the matching application version, and restore
books if needed. State belongs to `kavita:kavita`; the secrets directory and
key belong to root with modes `0700` and `0600`. Test a restore in isolation,
including login, opening a book, and reading progress, before replacing
production state. Keep the Cloudflare credentials separately recoverable.

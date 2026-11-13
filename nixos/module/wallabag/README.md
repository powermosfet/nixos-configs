# Wallabag on zook

Wallabag runs natively with PHP 8.3, SQLite, and nginx. Its only HTTPS listener
is `100.119.101.124:443`, zook's Tailscale IPv4 address. Registration is disabled;
email is disabled until an SMTP transport is deliberately configured. There is
no Tailscale Serve or Funnel configuration.

Run the integration test with:

```console
nix-build nixos/service/wallabag/test.nix --no-out-link
```

It checks installation, randomized credentials, login through nginx/PHP-FPM,
listener isolation, static images, restart persistence, snapshot restoration,
and refusal to downgrade or reset an existing database.

## Before deploying

1. In Cloudflare, create a **DNS only** A record:
   `les.berge.id` → `100.119.101.124`. Do not enable the orange-cloud proxy.
   Do not add an AAAA record: this deployment listens on IPv4 only.
2. Create a Cloudflare API token with **Zone / Zone / Read** and
   **Zone / DNS / Edit**, scoped to **berge.id**. See the
   [lego Cloudflare provider documentation](https://go-acme.github.io/lego/dns/cloudflare/).
3. On zook, create `/var/lib/acme/cloudflare.env`, owned by root with mode
   `0600`, using an editor rather than putting the token in shell history:

   ```console
   sudo install -d -m 0755 /var/lib/acme
   sudoedit /var/lib/acme/cloudflare.env
   sudo chmod 0600 /var/lib/acme/cloudflare.env
   ```

   Its contents are:

   ```dotenv
   CF_DNS_API_TOKEN=your-token
   CF_ZONE_API_TOKEN=your-token
   ```

   Both variables can contain the same token with the permissions above. Keep
   this file outside the repository and Nix store. Existing ACME configuration
   for other hostnames is unaffected. DNS-01 uses public DNS to validate a TXT
   record; it does not need inbound HTTP access to zook.
4. Confirm zook still has that Tailscale address, and that your tailnet policy
   allows your devices to reach zook on TCP 443. nginx waits up to 60 seconds
   for the address at startup. Because nginx is shared with SilverBullet,
   missing Tailscale connectivity also prevents nginx from starting.
5. Rebuild zook using its usual host configuration. This repository exports
   modules, rather than a standalone `nixosConfigurations.zook` deployment.
   Include the new files when deploying the repository (Git flakes omit untracked
   files). No database service on mook is needed.

## First login and checks

The first PHP-FPM startup installs Wallabag and replaces the installer password
with a random password before accepting requests. The account is `wallabag`.
Read its initial password on zook:

```console
sudo cat /var/lib/wallabag/data/initial-admin-password
```

Visit <https://les.berge.id> while connected to Tailscale. Change the password
and account email in Wallabag, then remove the initial-password file. The file
is not updated when you change your password.

Check units and certificate issuance:

```console
systemctl status phpfpm-wallabag nginx acme-les.berge.id
journalctl -u phpfpm-wallabag -u acme-les.berge.id
curl -I https://les.berge.id/login
```

Save an article containing images, open it again, and test the browser extension
or mobile client's API connection. They use the same HTTPS URL and require
Tailscale connectivity. Reboot and verify the article is still present.

From a LAN device, requests to zook's LAN address with `les.berge.id` as both
the TLS SNI and HTTP Host must not reach Wallabag. For example, substitute zook's
LAN address below:

```console
curl -kI --resolve les.berge.id:443:192.168.1.11 https://les.berge.id/login
```

It may reach a different nginx virtual host or fail, but must not serve Wallabag.
Also test without Tailscale from outside the LAN. The public DNS record alone
does not give a device a route to the Tailscale address.

## Administration and upgrades

Run console commands as the service user; the wrapper selects the same runtime,
production environment, and state directory as PHP-FPM:

```console
sudo -u wallabag wallabag-console list
sudo -u wallabag wallabag-console fos:user:change-password wallabag
```

State is under `/var/lib/wallabag`: SQLite in `data/db`, the application secret
in `data/secret`, site-credentials encryption keys in `data`, images in
`web/assets/images`, and imports in `web/uploads/import`. `app` is generated
from the selected package and deployment settings on every startup; edit the
Nix configuration rather than that generated directory.

When the package store path changes, PHP-FPM is stopped and a timestamped tar
snapshot of configuration and persistent content is written under
`/var/lib/wallabag-backups` before migrations run. Startup then refreshes
packaged configuration, clears cache, applies migrations, and warms the cache.
Initialization only runs once. A failed migration prevents PHP-FPM from starting.
Snapshots are retained until manually pruned after checking remote backups.
Do not run administrative writes or imports from the console during upgrades
or Borg backups.

Version downgrades are refused. Rolling back the NixOS generation does not undo
database migrations: restore a snapshot matching the old package as well. After
a deliberate restore, check that `.package` and `.version` match that package
before starting the service. These metadata files are included in each snapshot.

If installation fails before `.initialized` is written, startup refuses to reset
an existing database. Inspect the journal and preserve the directory before
recovery. If this was a new installation with no useful data, move the whole
directory aside while PHP-FPM is stopped, then start the service to install into
a fresh directory. Do not remove the marker from a populated installation or
rerun `wallabag:install` against it; that command can reset internal settings.

## Backups and restore

Both existing zook Borg jobs include `/var/lib/wallabag` and
`/var/lib/wallabag-backups`. They stop `phpfpm-wallabag.service` while archiving
and restart it afterward, so the SQLite database and images are copied with
application writes paused. Borg archives symlinks without following them; package
code remains reproducible from Nix. Cache and logs are included in the state
directory, but may be discarded during recovery.

For a restore test, extract an archive into a separate directory, preserve the
database, `data` keys, generated configuration, images, and hidden metadata, and
use the matching Wallabag package. Verify SQLite `PRAGMA integrity_check`, login,
article text, and saved images before replacing production state. Do not run a
second writable application against the production database.

For production recovery, stop `phpfpm-wallabag`, preserve the current directory,
restore the archive at `/var/lib/wallabag`, and ensure ownership is `wallabag:wallabag`.
Restore the matching Nix generation if undoing an upgrade, then start PHP-FPM.
The startup script rebuilds configuration and cache. Keep the Cloudflare token
separately recoverable; it is intentionally outside the Wallabag backup paths.

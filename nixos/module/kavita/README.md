# Kavita on mook

Kavita runs alongside Nextcloud on mook at https://bok.berge.id. nginx proxies
from HTTPS to Kavita on localhost and allows only Tailscale IPv4 clients, using
mook's normal nginx listeners. Cloudflare DNS must point to mook's Tailscale IP.

## Required local configuration

Set `services.kavita.libraryDir` in mook's local NixOS configuration to the
absolute path you want to share. This option deliberately has no default:
rebuilding without it fails. Choose a dedicated directory outside Nextcloud's
internal data directory. No value is assigned in this repository.

The module creates the directory owned by `nextcloud:kavita-library`, with mode
`2770` and default ACLs so uploaded files remain accessible to the shared group.
Both service users join that group; Kavita's service sees the directory read-only.
The filesystem must support POSIX ACLs, and parent directories must allow traversal.
Existing contents are not recursively changed: ensure the shared group can read
files and traverse subdirectories if reusing an existing directory. Kavita waits
for the mount containing the library before starting.

## Uploading through Nextcloud

Enable Nextcloud's bundled **External storage support** app (or run
`sudo nextcloud-occ app:enable files_external`). In Nextcloud's administration
settings, add a **Local** external storage named Books with the exact absolute
path configured in `services.kavita.libraryDir`. Restrict availability to the
users who should be allowed to upload or manage books.

See Nextcloud's [Local external storage documentation](https://docs.nextcloud.com/server/stable/admin_manual/configuration_files/external_storage/local.html).

In Kavita, add that same path to your library. Upload book folders through
Nextcloud's Books folder, then scan the library in Kavita (or enable folder
watching). Keep each book or series in a subdirectory of the library root.
The option prepares filesystem access; it does not create either application's
library/external-storage entry.

## Moving from zook

1. Back up and stop Kavita on zook. Copy `/var/lib/kavita` and
   `/var/lib/kavita-secrets` to mook, preserving ownership and permissions.
   Resolve the `kavita` ownership on mook by user/group name, since numeric IDs
   may differ. The secrets directory and key remain root-owned, modes `0700`
   and `0600`. Preserve the existing signing key and database to retain accounts
   and reading progress; don't initialize a second instance over that state.
2. Move the books from the old library to the chosen shared directory and give
   them group `kavita-library`, group read access, and directory traversal.
   After migration, change the folder in Kavita's existing library to the new
   path before scanning. Don't scan the old missing path first.
3. Provide `/var/lib/acme/cloudflare.env` on mook, root-owned with mode `0600`.
   Its Cloudflare token needs zone read and DNS edit permissions for `berge.id`.
   Keep it outside Git and the Nix store.
4. Build and deploy mook through its usual host configuration, with the required
   library option set. This repository exports modules, not a standalone host
   deployment. Deploy zook's removal too; keep its old data until verification.
5. Change the Cloudflare **DNS-only A record** for `bok.berge.id` to mook's
   Tailscale IPv4 address. Remove any AAAA record. Tailnet policy must allow the
   intended clients to reach mook on TCP 443. No public port opening is required
   by this module; DNS-01 handles certificate validation.

For a fresh installation only, create the signing key before starting Kavita:

```console
sudo install -d -m 0700 -o root -g root /var/lib/kavita-secrets
sudo sh -c 'set -eu; umask 077; set -C; head -c 64 /dev/urandom | base64 --wrap=0 > /var/lib/kavita-secrets/token-key'
```

The NixOS module manages Kavita's user and state directory (default
`/var/lib/kavita`). Mook assigns port `8913` through its port table because
LubeLogger already uses Kavita's default port, `5000`.

## Verification and backups

Check `systemctl status kavita nginx acme-bok.berge.id`. Verify login and existing
reading progress, upload a sample book through Nextcloud, scan and open it in
Kavita, and check persistence after restart. Requests to mook's LAN or public IP
without a Tailscale source address must not serve Kavita, even with its hostname.

Both mook Borg jobs include Kavita's state, signing key directory, and the shared
library. They pause Kavita during backup; Nextcloud uploads can still run, so
avoid uploads during backup/restore. The existing gilli repository is unencrypted;
these paths inherit that policy. Keep Cloudflare credentials separately recoverable.

A NixOS rollback does not undo database migrations. Restore application state
with the matching Kavita package and signing key, with Kavita stopped. Test
login, book access, and reading progress before replacing production state.

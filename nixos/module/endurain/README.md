The mook deployment imports the reusable service in `nixos/service/endurain`
(also exported as `nixosModules.endurain`). It runs the upstream Endurain Docker
image and connects to the host PostgreSQL server through `/run/postgresql`,
using a password-authenticated database role restricted to the Endurain database.
Nginx serves it at https://svette.berge.id, forwarding to loopback port 8904.

On first start, `endurain-init` generates the database password, signing key,
and URL-safe Fernet key in `/var/lib/endurain/secrets.env` (root-only). The
database setup service ensures the role and database exist and installs that
password before the container starts. This also handles enabling Endurain while
PostgreSQL is already running, without restarting the shared database server.
Keep this file when restoring backups: the Fernet key protects stored
integration credentials. Application data and logs live alongside it, and both
the directory and database are included in the existing backup configuration.

The service supports image, URL, address, port, storage, container UID/GID,
environment, runtime environment files, and additional volume options. Extra
upstream settings (SMTP, integrations, session settings, etc.) go in
`services.endurain.environment`; secrets can be supplied in `environmentFiles`.
Disable `generateSecrets` when supplying all secrets yourself. The mook deployment
expects its generated `secrets.env` for database password setup.

The default image tag is `latest`; set `services.endurain.image` to a version or
digest to pin upgrades. The container module's default pull policy only pulls
missing images. Upstream documents an initial `admin` / `admin` login; change
the password after first login.

References: [upstream deployment](https://github.com/endurain-project/endurain/blob/master/docker-compose.yml.example)
and [supported environment variables](https://docs.endurain.com/getting-started/advanced-started/).

The old workout-tracker server module and Garmin uploader have been removed.
Garmin activities will be imported through Endurain's Garmin Connect integration.

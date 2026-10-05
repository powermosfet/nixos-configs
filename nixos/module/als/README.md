# ALS deployment

The mook machine module imports this deployment module, which enables the ALS
RabbitMQ to Microsoft To Do worker and configures the local RabbitMQ endpoint.
The reusable service definition lives in `../../service/als` and is exported as
`nixosModules.als` by the shared configuration flake. ALS has no HTTP listener.

In the local flake that builds mook, add the current ALS flake as an input and
supply its package in a NixOS module (with `inputs` and `pkgs` in scope):

```nix
services.als = {
  package = inputs.als.packages.${pkgs.stdenv.hostPlatform.system}.default;
  settings = {
    CLIENT_ID = "your-microsoft-application-id";
    LIST_ID = "your-microsoft-to-do-list-id";
  };
  environmentFile = "/run/secrets/als";
};
```

The package has no default and must be provided when the service is enabled.
Replace the old `port`, `clientId`, `listId`, `redirectUrl`, `accessToken` and
`refreshToken` options with `settings` and a runtime environment file. Do not
also import the upstream ALS NixOS module: it defines the same service options.

Provision the optional environment file before the service starts, using systemd
EnvironmentFile syntax, for example:

```text
RABBITMQ_USERNAME=als
RABBITMQ_PASSWORD=your-secret
ACCESS_TOKEN=your-initial-access-token
REFRESH_TOKEN=your-initial-refresh-token
```

Keep credentials outside the repository and Nix store. Obtain initial tokens
using the current ALS package's `als --auth` device-code flow with `CLIENT_ID`
set and `TOKEN_FILE` unset, then save the returned tokens in the environment
file. Microsoft requires a public-client app supporting your account type with
public client flows enabled and delegated `Tasks.ReadWrite` and `offline_access`
permissions. `REDIRECT_URL` is only needed for the legacy `--auth-code` flow.

The service defaults `TOKEN_FILE` to `/var/lib/als/tokens.json`. Its private
state directory persists across restarts and rebuilds and allows ALS to atomically
save refreshed tokens with mode `0600`. A missing token file bootstraps from the
environment tokens; an existing file takes precedence. Keep `TOKEN_FILE` within
this writable state directory. Authentication failures exit with status 78 and
leave the service stopped. To reauthenticate, stop the service, obtain fresh
tokens, update the environment file, remove the old token file (if present), then
run `systemctl reset-failed als.service` and `systemctl start als.service`.

Provision the RabbitMQ user, virtual host, existing queue, bindings and permissions
separately: ALS does not declare queues. Defaults are user/password `guest`, vhost
`/`, and queue `shopping-list-items`. IBS must publish to the queue ALS consumes;
override `RABBITMQ_QUEUE` in `settings` if needed. Other supported settings include
`RETRY_DELAY_SECONDS` (default `5`) and `HTTP_TIMEOUT_SECONDS` (default `30`).
Environment-file values override `settings`.

Inspect logs with `journalctl -u als.service`.

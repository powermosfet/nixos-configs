# IBS deployment

The mook machine module imports this deployment module, which enables IBS and
configures local RabbitMQ and the barcode-backend product lookup endpoint.
The reusable service definition lives in `../../service/ibs` and is also exported
as `nixosModules.ibs` by the shared configuration flake.

In the local flake that builds mook, add the IBS flake as an input and supply its
package in a NixOS module (with `inputs` and `pkgs` in scope):

```nix
services.ibs = {
  package = inputs.ibs.packages.${pkgs.stdenv.hostPlatform.system}.default;
  environmentFile = "/run/secrets/ibs";
};
```

The package has no default and must be provided when the service is enabled.
The environment file is optional; if configured, provision it before the service
starts. It uses systemd EnvironmentFile syntax, for example:

```text
RABBITMQ_USERNAME=ibs
RABBITMQ_PASSWORD=your-secret
```

Keep that file outside the repository and Nix store. The RabbitMQ user and its
queue permissions must be provisioned separately. Without overrides, IBS uses
its upstream `guest` credentials and default queue names. Public settings can be
set with `services.ibs.settings`; environment-file values take precedence.

Inspect logs with `journalctl -u ibs.service`.

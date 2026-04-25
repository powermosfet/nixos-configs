{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
with builtins;

let
  job = "agent25";
  service = "borgbackup-job-${job}";
  onSuccessService = "${service}-notify-success";
  onFailureService = "${service}-notify-failure";
in
{
  imports = [
    ../../../default.nix
    ../../../../tailscale
  ];

  config = {
    services.borgbackup.jobs."${job}" = {
      paths = config.backup.paths;
      encryption.mode = "keyfile";
      environment.BORG_RSH = "ssh -i /root/.ssh/id_borg-main-agent25";
      repo = "ssh://borg@agent25/./";
      compression = "auto,zstd";
      startAt = "04:00";
    };
    systemd.services = {
      "${service}" = {
        conflicts = config.backup.conflictingServices;
        postStop = concatStringsSep "\n" (
          map (service: "systemctl start " + service) config.backup.conflictingServices
        );
        onSuccess = [ "${onSuccessService}.service" ];
        onFailure = [ "${onFailureService}.service" ];
      };
      "${onSuccessService}" = (
        import ../../notify.nix {
          inherit pkgs service;
          status = "succeeded";
        }
      );
      "${onFailureService}" = (
        import ../../notify.nix {
          inherit pkgs service;
          status = "failed";
        }
      );
    };
  };
}

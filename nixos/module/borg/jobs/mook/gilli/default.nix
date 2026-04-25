{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
with builtins;

let
  mookPorts = import ../../../../../machine/mook/ports.nix;
  strPort = toString mookPorts.exposed.pms;
  job = "gilli";
  service = "borgbackup-job-${job}";
  onSuccessService = "${service}-notify-success";
  onFailureService = "${service}-notify-failure";
in
{
  imports = [
    ../../../default.nix
  ];

  config = {
    services.borgbackup.jobs."gilli" = {
      paths = config.backup.paths;
      encryption.mode = "none";
      environment.BORG_RSH = "ssh -i /root/.ssh/id_borg-main-gilli";
      repo = "ssh://borg@gilli.local/./";
      compression = "auto,zstd";
      startAt = "05:00";
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

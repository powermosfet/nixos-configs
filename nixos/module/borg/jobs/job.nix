{
  job,
  repo,
  encrypt,
  startAt,
}:
{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
with builtins;

let
  service = "borgbackup-job-${job}";
  onSuccessService = "${service}-notify-success";
  onFailureService = "${service}-notify-failure";
in
{
  imports = [
    ../default.nix
  ];

  options = {
    backup.job."${job}".identityFile = mkOption {
      description = "Identity file for Borg backup job '${job}'";
      type = types.path;
      default = [ ];
    };
  };

  config = {
    services.borgbackup.jobs."${job}" = {
      paths = config.backup.paths;
      encryption.mode = if encrypt then "keyfile" else "none";
      environment.BORG_RSH = "ssh -i ${config.backup.job."${job}".identityFile}";
      repo = repo;
      compression = "auto,zstd";
      startAt = startAt;
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
        import ./notify.nix {
          inherit pkgs service;
          status = "succeeded";
        }
      );
      "${onFailureService}" = (
        import ./notify.nix {
          inherit pkgs service;
          status = "failed";
        }
      );
    };
  };
}

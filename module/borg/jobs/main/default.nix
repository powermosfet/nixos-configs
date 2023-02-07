{ config, pkgs, lib, ... }:

  with lib;
  with builtins;

let
  pauseConflicting = listToAttrs (map (service:
    { name = "systemd.services." + service;
      value = {
        conflicts = (map (job:
            "borgbackup-job-" + job + ".service"
          ) (attrNames config.services.borgbackup.jobs));
        postStop = "systemctl start " + service;
      };
    }) config.backup.conflictingServices);
in
{
  options = {
    backup.paths = mkOption {
      description = "directories to back up";
      type = types.listOf types.path;
    };

    backup.conflictingServices = mkOption {
      description = "conflicting services to be paused while backing up";
      type = types.listOf types.string;
    };
  };

  config = {
    services.borgbackup.jobs."main-gilli" = {
      paths = config.backup.paths;
      encryption.mode = "none";
      environment.BORG_RSH = "ssh -i /root/.ssh/id_borg-main-gilli";
      repo = "borg@gilli.local:.";
      compression = "auto,zstd";
    };
  } // pauseConflicting;
}

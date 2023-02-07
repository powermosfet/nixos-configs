{ config, pkgs, lib, ... }:

  with lib;
  with builtins;

let
  conflictingServices = [
    "minecraft-server";
  ];

  pauseConflicting = listToAttrs (map (service:
    { name = "systemd.services." + service + ".conflicts";
    , value = {
      conflicts = (map (job:
          "borgbackup-job-" + job + ".service"
        ) (attrNames config.services.borgbackup.jobs));
      postStop = "systemctl start " + service;
      }
    }));
in
{
  options = {
    backup.paths = mkOption {
      description = "directories to back up";
      type = types.listOf types.path;
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

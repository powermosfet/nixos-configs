{ config, pkgs, lib, ... }:

  with lib;
  with builtins;

{
  options = {
    backup.paths = mkOption {
      description = "directories to back up";
      type = types.listOf types.path;
    };

    backup.conflictingServices = mkOption {
      description = "conflicting services to be paused while backing up";
      type = types.listOf types.str;
    };
  };

  config = {
    services.borgbackup.jobs."main-gilli" = {
      paths = config.backup.paths;
      encryption.mode = "none";
      environment.BORG_RSH = "ssh -i /root/.ssh/id_borg-main-gilli";
      repo = "borg@gilli.local:.";
      compression = "auto,zstd";
      startAt = "04:00";
    };
    systemd.services."borgbackup-job-main-gilli" = {
      conflicts = config.backup.conflictingServices;
      postStop = concatStringsSep "\n" (map (service:
        "systemctl start " + service
        ) config.backup.conflictingServices);
    };

    services.borgbackup.jobs."main-agent25" = {
      paths = config.backup.paths;
      encryption.mode = "keyfile";
      environment.BORG_RSH = "ssh -i /root/.ssh/id_borg-main-agent25";
      repo = "ssh://borg@agent25.berge.id:222/./";
      compression = "auto,zstd";
      startAt = "04:00";
    };
    systemd.services."borgbackup-job-main-agent25" = {
      conflicts = config.backup.conflictingServices;
      postStop = concatStringsSep "\n" (map (service:
        "systemctl start " + service
        ) config.backup.conflictingServices);
    };
  };
}

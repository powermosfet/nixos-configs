{ config, pkgs, lib, ... }:

{
  options = {
    backup.paths = mkOption {
      description = "directories to back up";
      type = types.listOf types.path;
    };
  };

  config = {
    services.borgbackup.jobs."main-gilli" = {
      encryption.mode = "none";
      environment.BORG_RSH = "ssh -i /root/.ssh/id_borg-main-gilli";
      repo = "borg@gilli.local:.";
      compression = "auto,zstd";
    };
  };
}

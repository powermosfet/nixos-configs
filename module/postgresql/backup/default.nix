{ pkgs, config, lib, ... }:

  with lib;

{
  config = {
    services.postgresqlBackup = {
      enable = true;
      backupAll = false;
    };


    services.borgbackup.jobs."postgresql-gilli" = {
      paths = services.postgresqlBackup.location;
      encryption.mode = "none";
      environment.BORG_RSH = "ssh -i /root/.ssh/id_borg-main";
      repo = "borg@gilli.local:.";
      compression = "auto,zstd";
    };
  };
}

{ pkgs, config, lib, ... }:

{
  config = {
    services.postgresqlBackup = {
      enable = true;
      backupAll = false;
    };

    backup.paths = [ config.services.postgresqlBackup.location ];
  };
}

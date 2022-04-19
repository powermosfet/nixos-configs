{ pkgs, ... }:

{
  config = {
    services.postgresqlBackup = {
      enable = true;
      backupAll = true;
    };
  };
}

{ pkgs, ... }:

{
  config = {
    services.postgresqlBackup = {
      enable = true;
      user = "backup";
      backupAll = true;
    };
  };
}

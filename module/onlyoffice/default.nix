{ pkgs, config, ... }:

{
  imports =
    [
    ];

  config = {
    services.onlyoffice = {
      enable = true;
    };

    services.postgresqlBackup.databases = [ config.services.onlyoffice.postgresName ];
  };
}

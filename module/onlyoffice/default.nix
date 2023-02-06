{ pkgs, config, ... }:

let
  hostName = "onlyoffice.berge.id";
in
{
  imports =
    [
    ];

  config = {
    services.onlyoffice = {
      enable = true;

      inherit hostName;
    };

    services.postgresqlBackup.databases = [ config.services.onlyoffice.postgresName ];
  };
}

{ pkgs, config, ... }:

let
  hostname = "onlyoffice.berge.id";
in
{
  imports =
    [
    ];

  config = {
    services.onlyoffice = {
      enable = true;

      inherit hostname;
    };

    services.postgresqlBackup.databases = [ config.services.onlyoffice.postgresName ];
  };
}

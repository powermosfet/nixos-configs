{ pkgs, config, ... }:

let
  hostname = "onlyoffice.berge.id";
in
{
  config = {
    services.onlyoffice = {
      enable = true;

      inherit hostname;
    };

    services.postgresqlBackup.databases = [ config.services.onlyoffice.postgresName ];
    services.nginx.virtualHosts."${hostname}" = {
      enableACME = true;
      forceSSL = true;
    };
    services.ddclient.domains = [ hostname ];
  };
}

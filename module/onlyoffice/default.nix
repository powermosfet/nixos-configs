{ pkgs, config, ... }:

let
  hostname = "onlyoffice.berge.id";
in
{
  config = {
    services = {
      onlyoffice = {
        enable = true;

        inherit hostname;
      };

      postgresqlBackup.databases = [ config.services.onlyoffice.postgresName ];
      nginx.virtualHosts."${hostname}" = {
        enableACME = true;
        forceSSL = true;
      };
      ddclient.domains = [ hostname ];
    };
  };
}

{ config, pkgsUnstable, ... }:

let
  cfg = config.services.rsshub;
  hostName = "rss.berge.id";
in
{
  services.rsshub = {
    enable = true;
    package = pkgsUnstable.rsshub;
    settings.LISTEN_INADDR_ANY = false;
  };

  services.nginx.virtualHosts."${hostName}" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:${cfg.settings.PORT}";
  };

  services.ddclient.domains = [ hostName ];
}

{ config, pkgsUnstable, ... }:

let
  cfg = config.services.actual;
  hostname = "budsjett.berge.id";
in
{
  services.actual = {
    enable = true;
    package = pkgsUnstable.actual-server;
  };

  services.nginx.virtualHosts."${hostname}" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString (cfg.settings.port)}";
        proxyWebsockets = true;
      };
    };
  };
}

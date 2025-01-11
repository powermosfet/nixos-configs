{ pkgs, config, ... }:

let
  cfg = config.services.silverbullet;
  hostname = "sb.berge.id";
in
{
  config = {
    services.silverbullet = {
      enable = true;
    };

    services.nginx.virtualHosts."${hostname}" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          proxyPass = "http://${cfg.listenAddress}:${builtins.toString(cfg.listenPort)}";
          proxyWebsockets = true;
        };
      };
    };
  };
}

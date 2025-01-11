{ pkgs, config, ... }:

let
  cfg = config.services.silverbullet;
  hostname = "sb.berge.id";
in
{
  imports = [
    ../oauth2-proxy
  ];

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

    services.oauth2-proxy.nginx.virtualHosts."${hostname}".allowed_email_domains = [ "berge.id" ];
  };
}

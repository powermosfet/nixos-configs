{ pkgs, ... }:

{
  imports =
    [
    ];

  config = {
    services.tt-rss = {
      enable = true;
      virtualHost = "rss.berge.id";
      selfUrlPath = "https://${config.services.tt-rss.virtualHost}";
    };
    services.nginx.virtualHosts."${config.services.tt-rss.virtualHost}" = {
      enableACME = true;
      forceSSL = true;
    };
  };
}

{ pkgs, config, ... }:

{
  imports =
    [ 
    ];

  config = {
    services = {
      freshrss = {
        enable = true;
        virtualHost = "rss.berge.id";
        baseUrl = "https://${config.services.freshrss.virtualHost}";
      };
      nginx.virtualHosts."${config.services.freshrss.virtualHost}" = {
        enableACME = true;
        forceSSL = true;
      };
    };
  };
}


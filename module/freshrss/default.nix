{ pkgs, config, ... }:

{
  imports =
    [ 
    ];

  config = {
    services = {
      freshrss = {
        enable = true;
        virtualHost = "freshrss.berge.id";
        baseUrl = "https://${config.services.freshrss.virtualHost}";
      };
      nginx.virtualHosts."${config.services.freshrss.virtualHost}" = {
        enableACME = true;
        forceSSL = true;
      };
    };
  };
}


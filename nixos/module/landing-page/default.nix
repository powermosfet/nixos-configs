{ config, lib, ... }:

let
  cfg = config.services.landing-page;
in
{
  imports = [
    ../nginx
    ../acme
  ];

  options.services.landing-page = {
    enable = lib.mkEnableOption "the static landing page";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "www.berge.id";
      description = "Domain serving the static landing page.";
    };

    root = lib.mkOption {
      type = lib.types.path;
      default = "/var/www/landing-page";
      description = "Directory of public static files, readable by nginx.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts."${cfg.domain}" = {
      enableACME = true;
      forceSSL = true;
      root = cfg.root;
      locations."/".tryFiles = "$uri $uri/ =404";
    };

    networking.firewall.allowedTCPPorts = [ 80 ];
    services.ddclient.domains = [ cfg.domain ];

    systemd.tmpfiles.rules = [
      "d ${cfg.root} 0755 root root -"
    ];
  };
}

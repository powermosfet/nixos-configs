{
  pkgs,
  pkgsUnstable,
  config,
  ...
}:

let
  cfg = config.services.silverbullet;
  hostname = "sb.zook";
in
{
  imports = [
    ../tailscale
  ];

  config = {
    services.silverbullet = {
      enable = true;

      openFirewall = true;
      package = pkgsUnstable.silverbullet;
    };

    services.nginx = {
      virtualHosts."${hostname}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://${cfg.listenAddress}:${builtins.toString (cfg.listenPort)}";
            proxyWebsockets = true;
          };
        };
      };
    };
    services.ddclient.domains = [ hostname ];

    backup.paths = [ cfg.spaceDir ];
  };
}

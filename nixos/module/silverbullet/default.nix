{
  pkgs,
  pkgsUnstable,
  config,
  ...
}:

let
  cfg = config.services.silverbullet;
  hostname = "sb.berge.id";
in
{
  imports = [
    ../nginx
    ../acme
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

    backup.paths = [ cfg.spaceDir ];
  };
}

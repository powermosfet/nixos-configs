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

      package = pkgsUnstable.silverbullet;
      listenAddress = "127.0.0.1";
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

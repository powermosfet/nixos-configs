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
  ];

  config = {
    services.silverbullet = {
      enable = true;

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
  };
}

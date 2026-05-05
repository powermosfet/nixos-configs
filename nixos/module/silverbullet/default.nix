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
    security.acme.certs."sb.berge.id" = {
      dnsProvider = "cloudflare";
    };

    backup.paths = [ cfg.spaceDir ];
  };
}

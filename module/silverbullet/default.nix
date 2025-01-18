{ pkgs, config, ... }:

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
    };

    services.nginx = {
      virtualHosts."${hostname}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://${cfg.listenAddress}:${builtins.toString(cfg.listenPort)}";
            proxyWebsockets = true;
          };
        };
      };
    
      sso = {
        enable = true;

        configuration = {
          acl = {
            rule_sets = [
            {
              rules = [ { field = "domain"; equals = hostname; } ];
              allow = [ "asmund" ];
            }
            ];
          };
        };
      };
    };
  };
}

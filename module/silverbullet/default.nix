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
            
            extraConfig = ''
              # Protect this location using the auth_request
              auth_request /sso-auth;

              ## Optionally set a header to pass through the username
              #auth_request_set $username $upstream_http_x_username;
              #proxy_set_header X-User $username;

              # Automatically renew SSO cookie on request
              auth_request_set $cookie $upstream_http_set_cookie;
              add_header Set-Cookie $cookie;
            '';
          };
        };
      };
    
      sso = {
        enable = true;

        configuration = {
          acl = {
            rule_sets = [
            {
              rules = [ { field = "host"; equals = hostname; } ];
              allow = [ "asmund" ];
            }
            ];
          };
        };
      };
    };
  };
}

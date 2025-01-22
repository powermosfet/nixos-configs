{ pkgs, config, ... }:

let
  cfg = config.services.silverbullet;
  hostname = "sb.berge.id";
  autheliaConfig = pkgs.writeText "authelia-config-silverbullet.yml" ''
    # Authelia access control configuration
    access_control:
      default_policy: deny
      rules:
        - domain: ${hostname}
          policy: one_factor
  '';
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
          "/auth" = {
            proxyPass = "http://localhost:9091/api/verify";
            extraConfig = ''
              internal;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Auth-Request-User $remote_user;
            '';
          };

          "/" = {
            proxyPass = "http://${cfg.listenAddress}:${builtins.toString(cfg.listenPort)}";
            proxyWebsockets = true;
            
            extraConfig = ''
              # Protect this location using the auth_request
              auth_request /auth;
              error_page 401 = @error401;

              ## Optionally set a header to pass through the username
              #auth_request_set $username $upstream_http_x_username;
              #proxy_set_header X-User $username;

              # Automatically renew SSO cookie on request
              auth_request_set $cookie $upstream_http_set_cookie;
              add_header Set-Cookie $cookie;
            '';
          };

          "@error401" = {
            return = "302 https://auth.berge.id?redirect=$redirect";  
          };
        };
      };
    };

    services.authelia.instances.silverbullet = {
      enable = true;
      settingsFiles = [ autheliaConfig ];
    };
  };
}

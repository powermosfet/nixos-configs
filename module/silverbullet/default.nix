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
          resources:
            - '/.rpc/.*$'
            - '/.client/manifest.json$'
            - '/.client/[a-zA-Z0-9_-]+.png$'
            - '/service_worker.js$'
          policy: bypass
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
          "/.auth" = {
            proxyPass = "http://localhost:9091/api/verify";
            extraConfig = ''
              internal;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Auth-Request-User $remote_user;
              
              send_timeout 5m;
              proxy_read_timeout 360;
              proxy_send_timeout 360;
              proxy_connect_timeout 360;
            '';
          };

          "/" = {
            proxyPass = "http://${cfg.listenAddress}:${builtins.toString(cfg.listenPort)}";
            proxyWebsockets = true;
            
            extraConfig = ''
              # Protect this location using the auth_request
              auth_request /.auth;
              error_page 401 =302 https://auth.berge.id;

              ## Optionally set a header to pass through the username
              #auth_request_set $username $upstream_http_x_username;
              #proxy_set_header X-User $username;

              # Automatically renew SSO cookie on request
              auth_request_set $cookie $upstream_http_set_cookie;
              add_header Set-Cookie $cookie;

              send_timeout 5m;
              proxy_read_timeout 360;
              proxy_send_timeout 360;
              proxy_connect_timeout 360;
            '';
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

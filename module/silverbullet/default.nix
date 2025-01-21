{ pkgs, config, ... }:

let
  cfg = config.services.silverbullet;
  hostname = "sb.berge.id";
  autheliaConfig = pkgs.writeText "authelia-config-silverbullet.yml" ''
    # Authelia authentication backend
    authentication_backend:
      file:
        path: /var/lib/authelia/users_database.yml

    # Authelia access control configuration
    access_control:
      default_policy: deny
      rules:
        - domain: ${hostname}
          policy: one_factor

    # Authelia storage configuration
    storage:
      local:
        path: /var/lib/authelia/db.sqlite3
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
    };

    services.authelia.instances.silverbullet = {
      enable = true;
      settingsFiles = [ autheliaConfig ];
    };
  };
}

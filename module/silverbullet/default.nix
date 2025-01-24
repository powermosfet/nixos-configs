{ pkgs, config, ... }:

let
  cfg = config.services.silverbullet;
  hostname = "sb.berge.id";
  snippet = import ../authelia/nginx-snippets
  autheliaConfig = pkgs.writeText "authelia-config-silverbullet.yml" ''
    # Authelia access control configuration
    access_control:
      default_policy: deny
      rules:
        - domain: ${hostname}
          resources:
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
        extraConfig = ''
          include ${../authelia/snippet/authelia-location.conf};
          set $upstream https://${cfg.listenAddress}:${builtins.toString(cfg.listenPort)};
        '';
        locations = {
          "/" = {
            proxyPass = "$upstream";
            proxyWebsockets = true;
            
            extraConfig = ''
              include ${../authelia/snippet/proxy.conf};
              include ${../authelia/snippet/authelia-authrequest.conf};
              include ${../authelia/snippet/websocket.conf};
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

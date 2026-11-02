{
  config,
  pkgsUnstable,
  ...
}:

let
  cfg = config.services.immich;
  hostname = "bilder.berge.id";
in
{
  imports = [
    ../nginx
    ../acme
    ../tailscale
  ];

  config = {
    services.immich = {
      enable = true;
      package = pkgsUnstable.immich;
    };

    users.users."${cfg.user}".extraGroups = [
      "${config.backup.group}"
    ];

    services.nginx.virtualHosts."${hostname}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${cfg.host}:${toString cfg.port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 50000M;
          proxy_read_timeout   600s;
          proxy_send_timeout   600s;
          send_timeout         600s;

          allow 100.64.0.0/10;
          deny all;
        '';
      };
    };

    backup.paths = [ cfg.mediaLocation ];
    services.postgresqlBackup.databases = [ cfg.database.name ];
  };
}

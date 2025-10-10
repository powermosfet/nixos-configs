{
  config,
  ...
}:

let
  cfg = config.services.immich;
  hostname = "bilder.berge.id";
in
{
  services.immich = {
    enable = true;
  };

  users.users."${cfg.user}".extraGroups = [
    "${config.backup.group}"
  ];

  services.nginx.virtualHosts."${hostname}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://[::1]:${toString cfg.port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
      extraConfig = ''
        client_max_body_size 50000M;
        proxy_read_timeout   600s;
        proxy_send_timeout   600s;
        send_timeout         600s;
      '';
    };
  };

  backup.paths = [ cfg.mediaLocation ];
  services.postgresqlBackup.databases = [ cfg.database.name ];
}

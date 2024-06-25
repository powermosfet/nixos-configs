{ pkgs, config, ... }:

{
  imports =
    [ ../postgresql
    ];

  config = {
    services = {
      freshrss = {
        enable = true;
        virtualHost = "freshrss.berge.id";
        baseUrl = "https://${config.services.freshrss.virtualHost}";
        database = {
          type = "pgsql";
          host = "/run/postgresql";
        };
      };
      postgresql = {
        ensureDatabases = [ config.services.freshrss.database.name ];
        ensureUsers = [
          { name = config.services.freshrss.database.user;
            ensureDBOwnership = true;
          }
        ];
      };
      nginx.virtualHosts."${config.services.freshrss.virtualHost}" = {
        enableACME = true;
        forceSSL = true;
      };
    };
  };
}


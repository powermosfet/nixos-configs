{
  pkgs,
  config,
  pkgsUnstable,
  ...
}:

let
  hostName = "todo.berge.id";
  user = config.services.vikunja.database.user;
  database = config.services.vikunja.database.database;
  email = "little.tree8655@fastmail.com";
in
{
  config = {
    services.vikunja = {
      enable = true;
      package = pkgsUnstable.vikunja;
      setupNginx = true;
      frontendScheme = "https";
      frontendHostname = hostName;
      database = {
        type = "postgres";
        host = "/run/postgresql";
        # user = dbUser;
        # database = dbName;
      };
    };

    services.nginx.virtualHosts."${hostName}" = {
      enableACME = true;
      forceSSL = true;
    };
    security.acme.defaults.email = email;

    services.postgresql = {
      ensureUsers = [
        {
          name = user;
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [
        database
      ];
    };
    services.postgresqlBackup.databases = [
      database
    ];

    users.groups."${user}" = { };
    users.users."${user}" = {
      isSystemUser = true;
      group = user;
    };
    systemd.services.vikunja-api.serviceConfig = {
      User = user;
    };
  };
}

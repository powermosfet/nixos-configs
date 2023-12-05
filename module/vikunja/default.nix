{ pkgs, config, ... }:

let
  hostName = "todo.berge.id";
  email = "asmund@berge.id";
  dbName = "vikunja";
  dbUser = "vikunja";
in
{
  config = {
    services.vikunja = {
      enable = true;
      setupNginx = true;
      frontendScheme = "https";
      frontendHostname = hostName;
      database = {
        type = "postgres";
	host = "localhost";
	user = dbUser;
	database = dbName;
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
          name = dbUser;
          ensurePermissions = {
            "DATABASE ${dbName}" = "ALL PRIVILEGES";
          };
        }
      ];
      ensureDatabases = [
        dbName
      ];
    };
    services.postgresqlBackup.databases = [ dbName ];

    users.groups."${dbUser}" = {};
    users.users."${dbUser}" = {
      isSystemUser = true;
      group = dbUser;
    };
    systemd.services.vikunda-api.serviceConfig = {
      User = dbUser;
    };
  };
}



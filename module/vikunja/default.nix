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
      frondendHostname = hostName;
      database = {
        type = "postgres";
	host = "/run/postgresql";
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
  };
}



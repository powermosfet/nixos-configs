{ pkgs, config, ... }:

let
  unstable = import <nixos-unstable> { };
  hostName = "todo.berge.id";
  email = "asmund@berge.id";
  dbName = "vikunja";
  dbUser = "vikunja";
in
{
  config = {
    services.vikunja = {
      enable = true;
      package-api = unstable.vikunja-api;
      setupNginx = true;
      frontendScheme = "https";
      frontendHostname = hostName;
      database = {
        type = "postgres";
	# host = "/run/postgresql";
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
          name = dbUser;
          ensureDBOwnership = true;
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



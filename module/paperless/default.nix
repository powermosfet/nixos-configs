{ pkgs, config, ... }:

let
  hostName = "papir.berge.id";
  email = "asmund@berge.id";
  dbName = "paperless";
  dbUser = config.services.paperless.user;
in
{
  services.paperless = {
    enable = true;
    address = hostName;
    extraConfig = {
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_OCR_LANGUAGE = "nor+eng";
    };
  };

  services.nginx.virtualHosts."${hostName}" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString(config.services.paperless.port)}";
        proxyWebsockets = true;
      };
    };
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

  backup.paths = [ config.services.paperless.dataDir ];
}


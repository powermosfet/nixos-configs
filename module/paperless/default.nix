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
    consumptionDirIsPublic = true;
    extraConfig = {
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_OCR_LANGUAGE = "nor+eng";
      PAPERLESS_CONSUMER_ENABLE_ASN_BARCODE = true;
      PAPERLESS_CONSUMER_ASN_BARCODE_PREFIX = "00000";
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
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [
      dbName
    ];
  };
  services.postgresqlBackup.databases = [ dbName ];

  backup.paths = [ config.services.paperless.dataDir ];
}


{
  config,
  pkgs,
  pkgsUnstable,
  lib,
  ...
}:

with lib;
with builtins;

let
  hostName = "papir.berge.id";
  email = "little.tree8655@fastmail.com";
  dbName = "paperless";
  dbUser = config.services.paperless.user;
  preConsumptionScript = import ./preConsumptionScript.nix {
    pkgs = pkgs;
    passwordFile = config.services.paperless.pdfPasswordFile;
  };
in
{
  imports = [
    ../docker
    ../postgresql
  ];

  options = {
    services.paperless = {
      secretKey = mkOption {
        description = "Secret key";
        type = types.str;
      };

      pdfPasswordFile = mkOption {
        description = "password file for PDF decryption";
        type = types.path;
      };
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      file
      chromium
    ];

    services.paperless = {
      enable = true;
      package = pkgs.paperless-ngx;
      consumptionDirIsPublic = true;
      configureTika = true;
      settings = {
        PAPERLESS_URL = "https://${hostName}";
        PAPERLESS_DBHOST = "/run/postgresql";
        PAPERLESS_SECRET_KEY = config.services.paperless.secretKey;
        PAPERLESS_OCR_LANGUAGE = "nor+eng";
        PAPERLESS_CONSUMER_ENABLE_ASN_BARCODE = true;
        PAPERLESS_CONSUMER_ASN_BARCODE_PREFIX = "ASN";
      };
    };

    services.nginx.virtualHosts."${hostName}" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${builtins.toString (config.services.paperless.port)}";
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
  };
}

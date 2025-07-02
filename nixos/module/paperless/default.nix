{
  config,
  pkgs,
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
      gotenbergPort = mkOption {
        description = "Network port for Gotenberg";
        type = types.int;
      };

      tikaPort = mkOption {
        description = "Network port for Tika";
        type = types.int;
      };

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
      consumptionDirIsPublic = true;
      settings = {
        PAPERLESS_URL = "https://${hostName}";
        PAPERLESS_DBHOST = "/run/postgresql";
        PAPERLESS_SECRET_KEY = config.services.paperless.secretKey;
        PAPERLESS_OCR_LANGUAGE = "nor+eng";
        PAPERLESS_CONSUMER_ENABLE_ASN_BARCODE = true;
        PAPERLESS_CONSUMER_ASN_BARCODE_PREFIX = "ASN";
        PAPERLESS_PRE_CONSUME_SCRIPT = preConsumptionScript;
        PAPERLESS_TIKA_ENABLED = true;
        PAPERLESS_TIKA_ENDPOINT = "http://localhost:${builtins.toString (config.services.paperless.tikaPort)}";
        PAPERLESS_TIKA_GOTENBERG_ENDPOINT = "http://localhost:${builtins.toString (config.services.gotenberg.port)}";
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

    virtualisation.oci-containers.containers."tika" = {
      autoStart = true;
      image = "apache/tika";
      ports = [ "${builtins.toString (config.services.paperless.tikaPort)}:9998" ];
    };
    virtualisation.oci-containers.containers."gotenberg" = {
      autoStart = true;
      image = "gotenberg/gotenberg";
      ports = [ "${builtins.toString (config.services.paperless.gotenbergPort)}:3000" ];
    };
  };
}

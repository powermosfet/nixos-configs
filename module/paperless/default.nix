{ config, pkgs, lib, ... }:

  with lib;
  with builtins;

let
  hostName = "papir.berge.id";
  email = "little.tree8655@fastmail.com";
  dbName = "paperless";
  dbUser = config.services.paperless.user;
in
{
  imports =
    [ ../docker
      ../postgresql
    ];

  options = {
    services.paperless.gotenbergPort = mkOption {
      description = "Network port for Gothenberg";
      type = types.int;
    };

    services.paperless.secretKey = mkOption {
      description = "Secret key";
      type = types.str;
    };
  };

  config = {
    services.paperless = {
      enable = true;
      consumptionDirIsPublic = true;
      settings = {
        PAPERLESS_DBHOST = "/run/postgresql";
        PAPERLESS_SECRET_KEY = config.services.paperless.secretKey;
        PAPERLESS_OCR_LANGUAGE = "nor+eng";
        PAPERLESS_CONSUMER_ENABLE_ASN_BARCODE = true;
        PAPERLESS_CONSUMER_ASN_BARCODE_PREFIX = "ASN";
        PAPERLESS_TIKA_ENABLED = true;
        PAPERLESS_TIKA_ENDPOINT = "http://${config.services.tika.listenAddress}:${builtins.toString(config.services.tika.port)}";
        PAPERLESS_TIKA_GOTENBERG_ENDPOINT = "http://localhost:${builtins.toString(config.services.paperless.gotenbergPort)}";
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

    virtualisation.oci-containers.containers."gotenberg" = {
      autoStart = true;
      environment = {
      };
      image = "gotenberg/gotenberg";
      ports = [ "${builtins.toString(config.services.paperless.gotenbergPort)}:3000" ];
    };
    services.tika = {
      enable = true;
    };
  };
}

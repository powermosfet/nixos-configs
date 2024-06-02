{ config, pkgs, lib, ... }:

  with lib;
  with builtins;

let
  hostName = "papir.berge.id";
  email = "asmund@berge.id";
  dbName = "paperless";
  dbUser = config.services.paperless.user;
in
{
  imports =
    [ ../docker
    ];

  options = {
    services.paperless.gotenbergPort = mkOption {
      description = "Network port for Gothenberg";
      type = types.int;
    };
  };

  config = {
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

    virtualisation.oci-containers.containers."gotenberg" = {
      autoStart = true;
      environment = {
      };
      image = "gotenberg/gotenberg";
      ports = [ "${builtins.toString(config.services.paperless.gotenbergPort)}:3000" ];
    };
  };
}

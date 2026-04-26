{
  config,
  pkgs,
  lib,
  barcodeBackendFlake,
  ...
}:

with lib;

let
  barcode-backend = barcodeBackendFlake.packages.${pkgs.system}.default;
  cfg = config.services.barcode-backend;
  dbUser = "barcode";
  dbPort = config.services.postgresql.settings.port;
  dbName = "barcode";
in
{
  imports = [
    ../postgresql
    ../postgresql/backup
  ];

  options = {
    services.barcode-backend = {
      enable = mkEnableOption "Barcode backend service";

      port = mkOption {
        description = "Network port to listen on";
        default = 8080;
        type = types.int;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.barcode-backend = {
      description = "Barcode backend";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "postgresql.service"
      ];
      environment = {
        PORT = toString cfg.port;
        DB_HOST = "localhost";
        DB_USER = dbUser;
        DB_PW = "";
        DB_PORT = toString dbPort;
        DB_NAME = dbName;
      };
      serviceConfig = {
        ExecStart = "${barcode-backend}/bin/barcode-backend";
        User = dbUser;
      };
    };

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

    users.groups."${dbUser}" = { };
    users.users."${dbUser}" = {
      isSystemUser = true;
      group = dbUser;
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}

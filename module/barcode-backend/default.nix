{ config, pkgs, lib, ... }:

  with lib;

let
  cfg = config.services.barcode-backend;
  src = pkgs.fetchFromGitHub {
    owner = "powermosfet";
    repo  = "barcode-backend";
    rev = "db766fcc4e1cdfe67b72bf4f30fb3b9e1b4dd296";
    sha256 = "10ry3am7fqfylz0mda9lybp681x24js1gf2xh5w85jhqlmvzizid";
  };
  barcode-backend = import src { };
  dbUser = "barcode";
  dbPort = config.services.postgresql.port;
  dbName = "products";
in
{
  imports =
    [ ../postgresql
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
      after = [ "network.target" "postgresql.service" ];
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
          ensurePermissions = {
            "DATABASE ${dbName}" = "ALL PRIVILEGES";
          };
        }
      ];
      ensureDatabases = [
        dbName
      ];
    };

    users.groups."${dbUser}" = {};
    users.users."${dbUser}" = {
      isSystemUser = true;
      group = dbUser;
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}

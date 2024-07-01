{ config, pkgs, lib, ... }:

  with lib;

let
  cfg = config.services.meme;
  src = pkgs.fetchFromGitHub {
    owner = "powermosfet";
    repo  = "meme";
    rev = "0c90a3ddbefa0b7fcc1f6ca12ca9ddfa9de862c7";
    sha256 = "sha256-UvYK5tjmASCN5VOBkJ9X5PeLeBVBDD3+mBg7C/CAOyM=";
  };
  meme = import src { };
  dbUser = "meme";
  dbName = "meme";
in
{
  imports =
    [ ../postgresql
      ../postgresql/backup
    ];


  options = {
    services.meme = {
      enable = mkEnableOption "Memorise Every MQTT Event";

      mqttUri = mkOption {
        description = "MQTT URI";
        default = "mqtt://localhost";
        type = types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.meme = {
      description = "Memorise Every MQTT Event";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "postgresql.service" ];
      environment = {
        DB_CONNECTION_STRING = "";
        MQTT_URI = cfg.mqttUri;
      };
      serviceConfig = {
        ExecStart = "${meme}/bin/meme";
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

    users.groups."${dbUser}" = {};
    users.users."${dbUser}" = {
      isSystemUser = true;
      group = dbUser;
    };
  };
}


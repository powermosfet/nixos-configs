{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.meme;
  src = pkgs.fetchFromGitHub {
    owner = "powermosfet";
    repo = "meme";
    rev = "8b3a2e809a14e40f14d7a9ef7ee7dbd9e3cec1ef";
    sha256 = "sha256-nDcCFq4+HUKNrCzBOBnRSQExKkFvOxvBQHy7KMOo6sM=";
  };
  meme = import src { };
  dbUser = "meme";
  dbName = "meme";
  apiUser = "memeapi";
  postgrest = pkgs.postgrest;
  postgrestConf = pkgs.writeTextFile {
    name = "${dbName}.conf";
    text = ''
      db-uri = "postgres://${apiUser}@/${dbName}"
      db-schema = "public"
      db-anon-role = "${apiUser}"
      server-port = ${builtins.toString (cfg.port)}
    '';
  };
in
{
  imports = [
    ../postgresql
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

      mqttTopic = mkOption {
        description = "MQTT Topic";
        default = "#";
        type = types.str;
      };

      port = mkOption {
        description = "Web api port";
        type = types.int;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services = {
      meme-consumer = {
        description = "MEME - MQTT Consumer";
        wantedBy = [ "multi-user.target" ];
        after = [
          "network.target"
          "postgresql.service"
        ];
        environment = {
          DB_CONNECTION_STRING = "";
          MQTT_URI = cfg.mqttUri;
          MQTT_TOPIC = cfg.mqttTopic;
        };
        serviceConfig = {
          ExecStart = "${meme}/bin/meme";
          User = dbUser;
        };
      };
      meme-api = {
        description = "MEME - web api";
        wantedBy = [ "multi-user.target" ];
        after = [
          "network.target"
          "postgresql.service"
        ];
        serviceConfig = {
          User = apiUser;
          ExecStart = "${postgrest}/bin/postgrest ${postgrestConf}";
        };
      };
    };

    services.postgresql = {
      ensureUsers = [
        {
          name = dbUser;
          ensureDBOwnership = true;
        }
        { name = apiUser; }
      ];
      ensureDatabases = [
        dbName
      ];
      initialScript = pkgs.writeText "backend-initScript" ''
        GRANT CONNECT ON DATABASE ${dbName} TO ${apiUser};
        GRANT USAGE ON SCHEMA public TO ${apiUser};
        GRANT SELECT ON event TO ${apiUser};
      '';
    };
    services.postgresqlBackup.databases = [ dbName ];

    users.groups."${dbUser}" = { };
    users.users."${dbUser}" = {
      isSystemUser = true;
      group = dbUser;
    };
    users.groups."${apiUser}" = { };
    users.users."${apiUser}" = {
      isSystemUser = true;
      group = apiUser;
    };
  };
}

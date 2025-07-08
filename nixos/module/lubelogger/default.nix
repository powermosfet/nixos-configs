{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.lubelogger;
  dbName = "lubelogger";
  user = "lubelogger";
  group = "lubelogger";
  package = pkgs.lubelogger;
  hostname = "bil.berge.id";
  dataDir = "/var/lib/lubelogger/";
in
{
  options = {
    services.lubelogger = {
      email = {
        smtpHost = mkOption {
          description = "SMTP host";
          type = types.str;
        };
        smtpUser = mkOption {
          description = "SMTP username";
          type = types.str;
        };
        smtpPassword = mkOption {
          description = "SMTP password";
          type = types.str;
        };
        fromAddress = mkOption {
          description = "from address";
          type = types.str;
        };
      };
      admin = {
        usernameHash = mkOption {
          description = "SHA256 of username";
          type = types.str;
        };
        passwordHash = mkOption {
          description = "SHA256 of password";
          type = types.str;
        };
      };
      database = {
        password = mkOption {
          description = "Database password";
          type = types.str;
        };
      };
    };
  };

  config = {
    systemd.services.lubelogger = {
      description = "Vehicle Maintenance Records and Fuel Mileage Tracker";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        DOTNET_CONTENTROOT = dataDir;
        MailConfig__EmailServer = cfg.email.smtpHost;
        MailConfig__EmailFrom = cfg.email.fromAddress;
        MailConfig__Username = cfg.email.smtpUser;
        MailConfig__Password = cfg.email.smtpPassword;
        MailConfig__Port = "587";
        POSTGRES_CONNECTION = "Host=localhost:${toString config.services.postgresql.settings.port};Username=${user};Password=${cfg.database.password};Database=${dbName};";
        EnableAuth = "true";
        UserNameHash = cfg.admin.usernameHash;
        UserPasswordHash = cfg.admin.passwordHash;
        LUBELOGGER_OPEN_REGISTRATION = "true";
        LUBELOGGER_DOMAIN = "https://${hostname}";
        LANG = "nb_NO.UTF-8";
        LC_ALL = "nb_NO.UTF-8";
      };
      serviceConfig = {
        Type = "simple";
        User = user;
        Group = group;
        StateDirectory = baseNameOf dataDir;
        WorkingDirectory = dataDir;
        ExecStart = getExe package;
        Restart = "on-failure";
      };
    };
    users.groups."${group}" = { };
    users.users."${user}" = {
      isSystemUser = true;
      group = "${group}";
    };
    services.postgresql = {
      enable = true;
      ensureDatabases = [ dbName ];
      ensureUsers = [
        {
          name = user;
          ensureDBOwnership = true;
        }
      ];
    };
    services.postgresqlBackup.databases = [ dbName ];

    services.nginx.virtualHosts."${hostname}" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:5000";
          proxyWebsockets = true;
        };
      };
    };
  };
}

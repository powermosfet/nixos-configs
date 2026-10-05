{ config, lib, ... }:

let
  cfg = config.services.als;
in
{
  options.services.als = {
    enable = lib.mkEnableOption "ALS RabbitMQ to Microsoft To Do worker";

    package = lib.mkOption {
      type = lib.types.package;
      description = "The ALS worker package to run.";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        CLIENT_ID = "your-application-id";
        LIST_ID = "your-list-id";
        RABBITMQ_QUEUE = "shopping-list-items";
      };
      description = ''
        Environment variables configuring ALS. CLIENT_ID and LIST_ID must be
        supplied here or in environmentFile. Unspecified settings use the
        application's defaults. Store secrets in environmentFile instead.
        TOKEN_FILE defaults to /var/lib/als/tokens.json; any override must
        remain within the service's writable state directory.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/run/secrets/als";
      description = ''
        Absolute path to a runtime environment file containing settings such as
        RABBITMQ_PASSWORD, ACCESS_TOKEN and REFRESH_TOKEN. Values override
        settings. The file must exist before the service starts; its contents
        are not copied into the Nix store.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.als = {
      description = "ALS RabbitMQ to Microsoft To Do worker";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment = {
        TOKEN_FILE = "/var/lib/als/tokens.json";
      }
      // cfg.settings;

      serviceConfig = {
        ExecStart = lib.getExe' cfg.package "als";
        DynamicUser = true;
        StateDirectory = "als";
        StateDirectoryMode = "0700";
        UMask = "0077";
        Restart = "on-failure";
        RestartSec = "5s";
        RestartPreventExitStatus = [ 78 ];
        TimeoutStopSec = 15;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        NoNewPrivileges = true;
      }
      // lib.optionalAttrs (cfg.environmentFile != null) {
        EnvironmentFile = cfg.environmentFile;
      };
    };
  };
}

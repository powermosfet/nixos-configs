{ config, lib, ... }:

let
  cfg = config.services.ibs;
in
{
  options.services.ibs = {
    enable = lib.mkEnableOption "Iterative Barcode Searcher";

    package = lib.mkOption {
      type = lib.types.package;
      description = "The Iterative Barcode Searcher package to run.";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        PRODUCT_LOOKUP_URL_TEMPLATE = "http://localhost:8080/api/product/{barcode}";
        RABBITMQ_HOST = "localhost";
      };
      description = ''
        Environment variables configuring IBS. Unspecified settings use the
        application's defaults. PRODUCT_LOOKUP_URL_TEMPLATE must be supplied
        here or in environmentFile. Store secrets in environmentFile instead.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/run/secrets/ibs";
      description = ''
        Absolute path to a runtime environment file containing settings such as
        RABBITMQ_PASSWORD. Values override settings. The file must exist before
        the service starts; its contents are not copied into the Nix store.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.ibs = {
      description = "Iterative Barcode Searcher";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment = cfg.settings;

      serviceConfig = {
        ExecStart = lib.getExe' cfg.package "iterative-barcode-searcher";
        DynamicUser = true;
        Restart = "on-failure";
        RestartSec = "5s";
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        NoNewPrivileges = true;
      } // lib.optionalAttrs (cfg.environmentFile != null) {
        EnvironmentFile = cfg.environmentFile;
      };
    };
  };
}

{
  config,
  pkgs,
  lib,
  pkgsUnstable,
  pmsFlake,
  ...
}:

with lib;

let
  cfg = config.services.pms;
  pms = pmsFlake.packages.${pkgs.system}.default;
in
{
  options = {
    services.pms = {
      enable = mkEnableOption "pms service";

      port = mkOption {
        description = "Network port to listen on";
        default = 8080;
        type = types.int;
      };

      ntfy = {
        topic = mkOption {
          description = "Ntfy topic";
          type = types.str;
        };

        host = mkOption {
          description = "Nfy host";
          type = types.str;
          default = "ntfy.sh";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services = {
      pms = {
        description = "PMS Service (Personal Memo Sender).";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        environment = {
          APP_PORT = toString cfg.port;
          NTFY_TOPIC = cfg.ntfy.topic;
          NTFY_HOST = cfg.ntfy.host;
        };
        serviceConfig = {
          ExecStart = "${pms}/bin/pms";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}

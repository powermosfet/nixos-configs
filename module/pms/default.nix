{
  config,
  pkgs,
  lib,
  pkgsUnstable,
  ...
}:

with lib;

let
  cfg = config.services.pms;
  src = pkgs.fetchFromGitHub {
    owner = "powermosfet";
    repo = "pms";
    rev = "9d30c86d0b91ad9b9e4fdfe23d82232eff6d6e8a";
    sha256 = "0703mfs1vsghk8j78yiyjx84ksdj9jkl5ywa028b89kw8ilzq2yi";
  };
  pms = import src { };
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

      sender = mkOption {
        description = "Signal sender id (phone number)";
        type = types.str;
      };

      recipient = mkOption {
        description = "main recipient";
        type = types.str;
      };

      logRecipient = mkOption {
        description = "log recipient";
        type = types.str;
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
          SIGNAL_CLI = "${pkgsUnstable.signal-cli}/bin/signal-cli";
          SIGNAL_SENDER = cfg.sender;
          SIGNAL_RECIPIENT = cfg.recipient;
          SIGNAL_LOG_RECIPIENT = cfg.logRecipient;
          SIGNAL_CONFIG_PATH = "/root/.local/share/signal-cli";
        };
        serviceConfig = {
          ExecStart = "${pms}/bin/pms";
        };
      };
      pms-receive-timer = {
        serviceConfig.Type = "oneshot";
        path = with pkgs; [ bash ];
        script = ''
          ${pkgsUnstable.signal-cli}/bin/signal-cli -a ${cfg.sender} receive
        '';
      };
    };

    systemd.timers = {
      pms-receive-timer = {
        wantedBy = [ "timers.target" ];
        partOf = [ "pms-receive-timer.service" ];
        timerConfig = {
          OnCalendar = "*:0/1";
          Unit = "pms-receive-timer.service";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}

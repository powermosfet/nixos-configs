{ config, pkgs, lib, ... }:

  with lib;

let
  cfg = config.services.pms;
  src = pkgs.fetchFromGitHub {
    owner = "powermosfet";
    repo  = "pms";
    rev = "5524cf341faa0d0bfb386594ad56d25ac0a55c38";
    sha256 = "0lv3894n1f7qj576fcs00wcq2gqxhmsa2j1fvd100h14fyd3dxxq";
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
    systemd.services.pms = {
      description = "PMS Service (Personal Memo Sender).";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        APP_PORT = toString cfg.port;
        SIGNAL_CLI = "${pkgs.signal-cli}/bin/signal-cli";
        SIGNAL_SENDER = cfg.sender;
	SIGNAL_RECIPIENT = cfg.recipient;
	SIGNAL_LOG_RECIPIENT = cfg.logRecipient;
      };
      serviceConfig = {
        ExecStart = "${pms}/bin/pms";
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}

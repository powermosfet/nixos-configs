{ config, pkgs, lib, ... }:

  with lib;

let
  cfg = config.services.pms;
  src = pkgs.fetchFromGitHub {
    owner = "powermosfet";
    repo  = "pms";
    rev = "914ad1420f8f99390025ed50fc38ecd59a247c7b";
    sha256 = "1sh82i77q1ldarjcz2xw2p3j2md5xdw8kccazlqpvp3c9h58lwhd";
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

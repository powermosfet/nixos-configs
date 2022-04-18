{ config, pkgs, lib, ... }:

  with lib;

let
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/759a1f7742c76594955b8fc1c04b66dc409b8ff2.tar.gz") { };
  cfg = config.services.pms;
  src = pkgs.fetchFromGitHub {
    owner = "powermosfet";
    repo  = "pms";
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
    systemd.services.pms = {
      description = "PMS Service (Personal Memo Sender).";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        APP_PORT = toString cfg.port;
        SIGNAL_CLI = "${unstable.signal-cli}/bin/signal-cli";
        SIGNAL_SENDER = cfg.sender;
	SIGNAL_RECIPIENT = cfg.recipient;
	SIGNAL_LOG_RECIPIENT = cfg.logRecipient;
	SIGNAL_CONFIG_PATH = "/root/.local/share/signal-cli";
      };
      serviceConfig = {
        ExecStart = "${pms}/bin/pms";
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}

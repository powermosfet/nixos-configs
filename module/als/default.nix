{ config, pkgs, lib, ... }:

  with lib;

let
  cfg = config.services.als;
  src = pkgs.fetchFromGitHub {
    owner = "powermosfet";
    repo  = "als";
    rev = "70aa323eb556f8db3bbe66dc8db4da92727589e8";
    sha256 = "sha256-Xi0o+OLGLoh1Ttcem7FuHFh02UqHQ9OahJtPIPqBgbs=";
  };
  als = import src { pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/tarball/21.11") { }; };
in
{
  options = {
    services.als = {
      enable = mkEnableOption "als service";

      port = mkOption {
        description = "Network port to listen on";
        default = 8080;
        type = types.int;
      };

      clientId = mkOption {
        description = "Client ID for the API";
        type = types.str;
      };

      redirectUrl = mkOption {
        description = "Redirect url used for authentication";
        default = "https://auth-helper.herokuapp.com";
        type = types.str;
      };

      accessToken = mkOption {
        description = "Initial access token for the API";
        type = types.str;
      };

      refreshToken = mkOption {
        description = "Refresh token for the API";
        type = types.str;
      };

      listId = mkOption {
        description = "MS To-Do list id";
        type = types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.als = {
      description = "ALS Service.";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        PORT = toString cfg.port;
        CLIENT_ID = cfg.clientId;
	REDIRECT_URL = cfg.redirectUrl;
	ACCESS_TOKEN = cfg.accessToken;
	REFRESH_TOKEN = cfg.refreshToken;
        LIST_ID = cfg.listId;
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = "${als}/bin/als";
        Restart = "always";
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}


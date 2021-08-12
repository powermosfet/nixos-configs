{ config, pkgs, lib, ... }:

  with lib;

let
  cfg = config.services.als;
  src = pkgs.fetchFromGitHub {
    owner = "powermosfet";
    repo  = "als";
    rev = "d93b521aadc18204311ecf47851fd0140c2063c6";
    sha256 = "16k3kv6jdacna8zdgipdm2hyimilswgv60havlc2fc0jzr2vramd";
  };
  pkg = import src { };
  als = pkgs.callPackage pkg { };
  env = {
    PORT = port;
    CLIENT_ID = clientId;
  };

in {
  options.services.als = {
    enable = mkEnableOption "als service";

    port = mkOption {
      description = "Network port to listen on";
      default = 8080;
      type = types.int;
    };

    clientId = mkOption {
      description = "Client ID for the API";
      default = "deadbeef";
      type = types.string;
    };

    redirectUrl = mkOption {
      description = "Redirect url used for authentication";
      default = "https://auth-helper.herokuapp.com";
      type = types.str;
    };

    accessToken = mkOption {
      description = "Initial access token for the API";
      default = "";
      type = types.str;
    };

    refreshToken = mkOption {
      description = "Refresh token for the API";
      default = "";
      type = types.str;
    };

    listId = mkOption {
      description = "MS To-Do list id";
      default = "";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.als = {
      description = "ALS Service.";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = env;
      serviceConfig = {
        ExecStart = "${als}/bin/als";
      };
    };
  };
}


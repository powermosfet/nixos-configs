{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    zellij
  ];

  environment.sessionVariables = {
    ZELLIJ_CONFIG_FILE = ./config/config.kdl;
  };
}


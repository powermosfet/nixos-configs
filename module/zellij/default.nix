{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { };
in
{
  environment.systemPackages = [
    unstable.zellij
  ];

  environment.sessionVariables = {
    ZELLIJ_CONFIG_FILE = ./config/config.kdl;
  };
}


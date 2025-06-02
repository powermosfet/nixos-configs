{
  pkgs,
  config,
  lib,
  ...
}:

let
  unstable = import <nixos-unstable> {
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "minecraft-server"
      ];
  };
in
{
  config = {
    nixpkgs.config.allowUnfree = true;

    services.minecraft-server = {
      enable = true;
      package = unstable.minecraft-server;
      openFirewall = true;
      eula = true;
    };

    services.ddclient.domains = [ "minecraft.berge.id" ];

    backup = {
      paths = [ config.services.minecraft-server.dataDir ];
      conflictingServices = [
        "minecraft-server.service"
      ];
    };
  };
}

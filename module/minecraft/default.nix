{ pkgs, config, ... }:
  
let
  hash = "8efd5d1e283604f75a808a20e6cde0ef313d07d4";
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/${hash}.tar.gz") { config = config.nixpkgs.config; };
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

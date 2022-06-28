{ pkgs, config, ... }:

let
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/f2537a505d45c31fe5d9c27ea9829b6f4c4e6ac5.tar.gz") { config = config.nixpkgs.config; };
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
  };
}

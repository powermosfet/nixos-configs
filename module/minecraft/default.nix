{ pkgs, ... }:

let
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/3b6bc4b69ca7eec695291af31d8878071e0e084d.tar.gz") { };
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

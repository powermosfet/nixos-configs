{ pkgs, ... }:

{
  config = {
    nixpkgs.config.allowUnfree = true;

    services.minecraft-server = {
      enable = true;
      openFirewall = true;
      eula = true;
    };

    services.ddclient.domains = [ "minecraft.berge.id" ];
  };
}

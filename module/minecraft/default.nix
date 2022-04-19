{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  config = {
    services.minecraft-server = {
      enable = true;
      openFirewall = true;
      eula = true;
    };
  };
}

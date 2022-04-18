{ pkgs, ... }:

{
  imports =
    [
    ];
  
  config = {
    services.minecraft-server = {
      enable = true;
      openFirewall = true;
      eula = true;
    };
  };
}

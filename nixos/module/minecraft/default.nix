{
  pkgs,
  config,
  lib,
  pkgsUnstable,
  ...
}:

{
  config = {
    nixpkgs.config.allowUnfree = true;

    services.minecraft-server = {
      enable = true;
      package = pkgsUnstable.minecraft-server;
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

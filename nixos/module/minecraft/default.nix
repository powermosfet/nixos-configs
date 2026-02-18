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
      package = pkgsUnstable.papermc;
      openFirewall = true;
      eula = true;
      dataDir = "/var/lib/minecraft";
      declarative = true;
      serverProperties = {
        server-port = 25565;
        whitelist = true;
        difficulty = "hard";
        max-players = 4;
        level-name = "world";
        motd = "PaperMC Server";
        view-distance = 8;
        simulation-distance = 6;
      };

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

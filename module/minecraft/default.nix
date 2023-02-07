{ pkgs, config, ... }:
  
  with builtins;
let
  hash = "293a28df6d7ff3dec1e61e37cc4ee6e6c0fb0847";
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
    services.systemd.services."minecraft-server".conflicts = 
      (map (job:
        "borgbackup-job-" + job + ".service"
      ) (attrNames config.services.borgbackup.jobs));

    services.ddclient.domains = [ "minecraft.berge.id" ];

    backup.paths = [ config.services.minecraft-server.dataDir ];
  };
}

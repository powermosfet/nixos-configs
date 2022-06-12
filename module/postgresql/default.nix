{ config, pkgs, ... }:

{
  users.users.postgres = {
    isSystemUser = true;
  };

  services.postgresql = {
    enable = true;
    enableTCPIP = true;
  };

  networking.firewall.allowedTCPPorts = [ config.services.postgresql.port ];
}


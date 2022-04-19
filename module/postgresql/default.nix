{ config, pkgs, ... }:

{
  users.users.postgres = {
    isSystemUser = true;
  };

  services.postgresql = {
    enable = true;
  };
}


{ config, pkgs, ... }:

{
  imports =
    [
    ];

  users.users.postgres = {
    isSystemUser = true;
  };

  services.postgresql = {
    enable = true;
  };
}


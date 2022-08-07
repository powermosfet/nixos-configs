{ config, pkgs, ... }:

{
  users.users.postgres = {
    isSystemUser = true;
  };

  services.postgresql = {
    enable = true;

    extraPlugins = with pkgs.postgresql13Packages; [ pg_safeupdate ];
  };
}


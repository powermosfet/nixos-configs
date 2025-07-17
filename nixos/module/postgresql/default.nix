{ config, pkgs, ... }:

{
  users.users.postgres = {
    isSystemUser = true;
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;

    extensions = with pkgs.postgresql15Packages; [ pg_safeupdate ];
  };
}

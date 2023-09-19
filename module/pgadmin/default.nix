{ pkgs, ... }:

{
  services.pgadmin = {
    enable = true;
    openFirewall = true;
  };
}

{ pkgs, ... }:

{
  config = {
    services.node-red = {
      enable = true;
      group = "backup";
      openFirewall = true;
    };
  };
}

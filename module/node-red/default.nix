{ pkgs, ... }:

{
  config = {
    services.node-red = {
      enable = true;
      group = "backup";
      withNpmAndGcc = true;
      openFirewall = true;
    };
  };
}

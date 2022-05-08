{ pkgs, ... }:

{
  config = {
    users.groups.node-red = {};
    users.users.node-red = {
      isSystemUser = true;
      group = "node-red";
    };

    services.node-red = {
      enable = true;
      group = "backup";
      withNpmAndGcc = true;
      openFirewall = true;
    };
  };
}

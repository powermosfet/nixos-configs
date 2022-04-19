{ config, pkgs, ... }:

{
  users.groups.backup = {};
  users.users.backup = {
    isSystemUser = true;
    group = "backup";
  };
}


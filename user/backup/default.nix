{ config, pkgs, lib, ... }:

  with lib;

let
  cfg = config.backup;
in
{
  options = {
    backup = {
      user = mkOption {
        description = "User id for backup";
        type = types.str;
        default = "backup";
      };
      group = mkOption {
        description = "Default group for backup user";
        type = types.str;
        default = "backup";
      };
    };
  };

  config = {
    users.groups."${cfg.group}" = {};
    users.users."${cfg.user}" = {
      isSystemUser = true;
      group = "backup";
    };
  };
}


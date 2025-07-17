{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
with builtins;

{
  options = {
    backup.paths = mkOption {
      description = "directories to back up";
      type = types.listOf types.path;
      default = [ ];
    };

    backup.conflictingServices = mkOption {
      description = "conflicting services to be paused while backing up";
      type = types.listOf types.str;
      default = [ ];
    };
  };
}

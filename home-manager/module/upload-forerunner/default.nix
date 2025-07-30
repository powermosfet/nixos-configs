{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  mount-unit = "run-media-asmund-GARMIN.mount";
in
{
  options = {
    services.upload-forerunner = {
      api-key-file = mkOption {
        type = types.str;
        description = "Path to the api secret file";
      };

      backup-dir = mkOption {
        type = types.str;
        description = "Path to the backup directory";
      };
    };
  };

  config = {
    systemd.user.services.upload-forerunner = {
      Unit = {
        Description = "Upload new .fit files to workout-tracker";
        After = [
          "graphical-session.target"
          mount-unit
        ];
        BindsTo = [
          mount-unit
        ];
        Wants = [ mount-unit ];
      };
      Install = {
        WantedBy = [ mount-unit ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.writeShellScript "upload-forerunner" (
          import ./shell-script.nix { inherit pkgs config; }
        )}";
      };
    };
  };
}

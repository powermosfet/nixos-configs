{ pkgs, ... }:

let
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  find = "${pkgs.findutils}/bin/find";
  shuf = "${pkgs.coreutils}/bin/shuf";
  basename = "${pkgs.coreutils}/bin/basename";

  unit = "random-hyprpaper";
  dir = "bakgrunner";
in
{
  systemd.user.services."${unit}" = {
    Unit = {
      Description = "Set a random wallpaper using hyprpaper";
      After = "hyprland-session.target";
    };
    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
    Service = {
      Type = "oneshot";
      Environment = [
        "WALLPAPER_DIR=${dir}"
      ];
      ExecStart = (
        pkgs.writeShellScript "set-random-hyprpaper.sh" ''
          echo "Starting..."
          echo "WALLPAPER_DIR: $WALLPAPER_DIR"

          # Get a random wallpaper that is not the current one
          WALLPAPER=$(${find} "$HOME/$WALLPAPER_DIR" -type f | ${shuf} -n 1)
          echo "WALLPAPER: $WALLPAPER"

          # Apply the selected wallpaper
          ${hyprctl} hyprpaper wallpaper ,"$WALLPAPER"
        ''
      );
    };
  };

  systemd.user.timers."${unit}" = {
    Unit.Description = "timer for ${unit} service";
    Timer = {
      Unit = unit;
      OnBootSec = "15m";
      OnUnitActiveSec = "1h";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}

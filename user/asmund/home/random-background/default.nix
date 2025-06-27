{ pkgs, ... }:

let
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  find = "${pkgs.findutils}/bin/find";
  shuf = "${pkgs.coreutils}/bin/shuf";
  basename = "${pkgs.coreutils}/bin/basename";

  unit = "random-hyprpaper";
  dir = "bakgrunner/";
in
{
  systemd.user.services."${unit}" = {
    Unit = {
      Description = "Set a random wallpaper using hyprpaper";
      PartOf = "hyprland-session.target";
      After = "hyprland-session.target";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "set-random-hyprpaper.sh" ''
        #!/run/current-system/sw/bin/bash

        WALLPAPER_DIR="$HOME/${dir}"
        CURRENT_WALL=$(${hyprctl} hyprpaper listloaded)

        # Get a random wallpaper that is not the current one
        WALLPAPER=$(${find} "$WALLPAPER_DIR" -type f ! -name "$(${basename} "$CURRENT_WALL")" | ${shuf} -n 1)

        # Apply the selected wallpaper
        ${hyprctl} hyprpaper reload ,"$WALLPAPER"
      ''}";
    };
  };

  systemd.user.timers."${unit}" = {
    Unit.Description = "timer for battery_status service";
    Timer = {
      Unit = unit;
      OnBootSec = "15m";
      OnUnitActiveSec = "1h";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}

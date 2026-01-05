{ pkgs, ... }:

let
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  find = "${pkgs.findutils}/bin/find";
  shuf = "${pkgs.coreutils}/bin/shuf";
  basename = "${pkgs.coreutils}/bin/basename";

  unit = "andomr-hyprpaper";
  dir = "~/bakgrunner";
in
{
  systemd.user.services."${unit}" = {
    description = "Set a random wallpaper using hyprpaper";
    wantedBy = [ "hyprland-session.target" ];
    # after = [ "hyprland-session.target" ];
    environment = {
      WALLPAPER_DIR = dir;
    };
    script = (
      pkgs.writeShellScript "set-random-hyprpaper.sh" ''
        CURRENT_WALL=$(${hyprctl} hyprpaper listloaded)

        # Get a random wallpaper that is not the current one
        WALLPAPER=$(${find} "$WALLPAPER_DIR" -type f ! -name "$(${basename} "$CURRENT_WALL")" | ${shuf} -n 1)

        # Apply the selected wallpaper
        ${hyprctl} hyprpaper reload ,"$WALLPAPER"
      ''
    );
    serviceConfig = {
      Type = "oneshot";
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

{ pkgs, ... }:

let
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  find = "${pkgs.findutils}/bin/find";
  shuf = "${pkgs.coreutils}/bin/shuf";
  basename = "${pkgs.coreutils}/bin/basename";

  dir = "bakgrunner/";
in
{
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;
    };
  };

  systemd.user.services.random-hyprpaper = {
    Unit = {
      Description = "Set a random wallpaper using hyprpaper";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
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

}

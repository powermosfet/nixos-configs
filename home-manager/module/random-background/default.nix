{ pkgs, ... }:

let
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  shuf = "${pkgs.coreutils}/bin/shuf";
  ls = "${pkgs.coreutils}/bin/ls";
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
        "wallpaper_dir=${dir}"
      ];
      ExecStart = (
        pkgs.writeShellScript "set-random-hyprpaper.sh" ''
          echo "Starting..."
          echo "wallpaper_dir: $wallpaper_dir"

          gcd() {
            local a=$1
            local b=$2
            while [ "$b" -ne 0 ]; do
              local tmp=$b
              b=$((a % b))
              a=$tmp
            done
            echo "$a"
          }

          reduce_ratio() {
            local w=$1
            local h=$2
            local g=$(gcd "$w" "$h")
            echo "$((w / g)):$((h / g))"
          }

          hyprctl monitors -j | jq -c '.[]' | while read -r mon; do
            name=$(jq -r '.name' <<< "$mon")
            width=$(jq -r '.width' <<< "$mon")
            height=$(jq -r '.height' <<< "$mon")
            ratio=$(reduce_ratio "$width" "$height")

            # Get a random wallpaper that is not the current one
            wallpaper=$(${ls} "$HOME/$wallpaper_dir/$ratio" | ${shuf} -n 1)
            echo "wallpaper: $wallpaper"

            # Apply the selected wallpaper
            ${hyprctl} hyprpaper wallpaper "$name","$HOME/$wallpaper_dir/$ratio/$wallpaper"
          done
        ''
      );
    };
  };

  systemd.user.timers."${unit}" = {
    Unit.Description = "timer for ${unit} service";
    Timer = {
      Unit = unit;
      OnUnitActiveSec = "1h";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}

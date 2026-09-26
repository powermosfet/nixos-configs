{ pkgs, ... }:

let
  unit = "random-swaybg";
  dir = "bakgrunner";

  set-random-wallpaper = pkgs.writeShellApplication {
    name = "set-random-wallpaper";

    runtimeInputs = with pkgs; [
      coreutils
      findutils
      jq
      niri
      swaybg
    ];

    text = ''
      wallpaper_dir="$HOME/$wallpaper_dir"

      echo "Starting..."
      echo "wallpaper_dir: $wallpaper_dir"

      echo "NIRI_SOCKET=$NIRI_SOCKET"
      echo "socket exists: $(test -S "$NIRI_SOCKET" && echo yes || echo no)"

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
        local g
        g=$(gcd "$w" "$h")
        echo "$((w / g)):$((h / g))"
      }

      # Stop the previous swaybg instance.
      pkill -x swaybg || true

      # Build the swaybg arguments.
      args=()

      while read -r output; do
        name=$(jq -r '.name' <<< "$output")
        width=$(jq -r '.current_mode.width' <<< "$output")
        height=$(jq -r '.current_mode.height' <<< "$output")

        ratio=$(reduce_ratio "$width" "$height")

        wallpaper=$(
          find "$wallpaper_dir/$ratio" -maxdepth 1 -type f -printf '%f\n' |
          shuf -n 1
        )

        image="$wallpaper_dir/$ratio/$wallpaper"

        echo "output: $name"
        echo "resolution: ''${width}x''${height}"
        echo "ratio: $ratio"
        echo "wallpaper: $wallpaper"

        args+=(-o "$name" -i "$image")
      done < <(
        niri msg --json outputs |
          jq -c '.[]'
      )

      # Start one swaybg process for all outputs.
      swaybg -m fill "''${args[@]}" &
    '';
  };
in
{
  systemd.user.services."${unit}" = {
    Unit = {
      Description = "Set random wallpapers using swaybg";
      After = [ "niri.service" ];
      PartOf = [ "niri.service" ];
    };

    Install = {
      WantedBy = [ "niri.service" ];
    };

    Service = {
      Type = "oneshot";
      Environment = [
        "wallpaper_dir=${dir}"
        "NIRI_SOCKET=$NIRI_SOCKET"
      ];
      ExecStart = "${set-random-wallpaper}/bin/set-random-wallpaper";
    };
  };

  systemd.user.timers."${unit}" = {
    Unit = {
      Description = "Timer for ${unit} service";
    };

    Timer = {
      Unit = "${unit}.service";
      OnUnitActiveSec = "1h";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}

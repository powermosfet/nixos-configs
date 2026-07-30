{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
      targets = [ "hyprland-session.target" ];
    };

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        spacing = 5;
        modules-left = [
          "custom/launcher"
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-right = [
          "idle_inhibitor"
          "temperature"
          "cpu"
          "memory"
          "pulseaudio"
          "backlight"
          "battery"
          "tray"
          "clock"
        ];

        "hyprland/window" = {
          format = "{class}";
          max-length = 20;
        };
        "hyprland/workspaces" = {
          format = "{name}: {icon}";
          format-icons = {
            active = "";
            default = "";
          };
        };
        "custom/launcher" = {
          format = "🔍";
          on-click = "wofi --show drun";
          tooltip = false;
        };
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        "tray" = {
          spacing = 10;
        };
        "clock" = {
          format = "{:%a %m-%d %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        "cpu" = {
          format = "  {usage}%";
        };
        "memory" = {
          format = " {}%";
        };
        "temperature" = {
          thermal-zone = 2;
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format-critical = "{icon} {temperatureC}°C";
          format = "{icon} {temperatureC}°C";
          format-icons = [
            ""
            ""
            ""
          ];
        };
        "backlight" = {
          format = "{icon} {percent}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        "pulseaudio" = {
          scroll-step = 5;
          format = "{icon}  {volume}% {format_source}";
          format-bluetooth = " {icon} {volume}% {format_source}";
          format-bluetooth-muted = "  {icon} {format_source}";
          format-muted = "  {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
          on-click-right = "foot -a pw-top pw-top";
        };
      };
    };
  };
}

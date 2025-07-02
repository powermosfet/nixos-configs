{ config, pkgs, ... }:

let
  terminal = "kitty";
  zellij = "${terminal} --session ${../kitty/zellij.session}";
  quickie = "${terminal} --session ${../kitty/quickie.session}";
  fileManager = "pcmanfm";
  menu = "wofi --show drun";
  suspend = "systemctl suspend";
  mainMod = "SUPER";
in
{
  imports = [
    ../waybar
    ../kanshi
  ];

  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = [
        "[workspace 1 silent] ${zellij}"
        "[workspace 2 silent] firefox"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 7;
        border_size = 2;

        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        resize_on_border = true;
        allow_tearing = false;
        layout = "master";
      };
      decoration = {
        rounding = 5;
        rounding_power = 2;

        active_opacity = 1.0;
        inactive_opacity = 0.95;
      };

      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
          "specialWorkspace, 1, 6, default, slidefadevert -50%"
        ];
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        focus_on_activate = true;
      };

      input = {
        kb_model = "thinkpad";
        kb_layout = "no";
        kb_variant = "";
        kb_options = "caps:escape,numpad:mac";
        numlock_by_default = true;

        follow_mouse = 1;

        natural_scroll = true;
        touchpad = {
          clickfinger_behavior = 1;
          natural_scroll = true;
          disable_while_typing = true;
          tap-to-click = false;
        };
      };

      gestures = {
        workspace_swipe = true;
      };

      device = [
        {
          kb_model = "kinesis";
          name = "\"https://github.com/stapelberg\"-\"kint-(kint41)\"";
          kb_layout = "us";
          kb_variant = "altgr-intl";
          kb_options = "nodeadkeys";
        }
        {
          kb_model = "pc105";
          name = "gtips-reviung41";
          kb_layout = "us";
          kb_variant = "altgr-intl";
          kb_options = "nodeadkeys";
        }
      ];

      bind = [
        "${mainMod}, Q, exec, ${zellij}"
        "${mainMod}, X, exec, ${quickie}"
        "${mainMod}, C, killactive,"
        "${mainMod}, M, exit,"
        "${mainMod}, E, exec, ${fileManager}"
        "${mainMod}, V, togglefloating,"
        "${mainMod}, space, exec, ${menu}"
        "${mainMod}, L, exec, ${suspend}"
        "${mainMod}, left, movefocus, l"
        "${mainMod}, right, movefocus, r"
        "${mainMod}, up, movefocus, u"
        "${mainMod}, down, movefocus, d"
        "${mainMod}, Return, layoutmsg, swapwithmaster"
        "${mainMod}, 1, workspace, 1"
        "${mainMod}, 2, workspace, 2"
        "${mainMod}, 3, workspace, 3"
        "${mainMod}, 4, workspace, 4"
        "${mainMod}, 5, workspace, 5"
        "${mainMod}, 6, workspace, 6"
        "${mainMod}, 7, workspace, 7"
        "${mainMod}, 8, workspace, 8"
        "${mainMod}, 9, workspace, 9"
        "${mainMod}, 0, workspace, 10"
        "${mainMod}, KP_1, workspace, 1"
        "${mainMod}, KP_2, workspace, 2"
        "${mainMod}, KP_3, workspace, 3"
        "${mainMod}, KP_4, workspace, 4"
        "${mainMod}, KP_5, workspace, 5"
        "${mainMod}, KP_6, workspace, 6"
        "${mainMod}, KP_7, workspace, 7"
        "${mainMod}, KP_8, workspace, 8"
        "${mainMod}, KP_9, workspace, 9"
        "${mainMod}, KP_0, workspace, 10"
        "${mainMod} SHIFT, 1, movetoworkspace, 1"
        "${mainMod} SHIFT, 2, movetoworkspace, 2"
        "${mainMod} SHIFT, 3, movetoworkspace, 3"
        "${mainMod} SHIFT, 4, movetoworkspace, 4"
        "${mainMod} SHIFT, 5, movetoworkspace, 5"
        "${mainMod} SHIFT, 6, movetoworkspace, 6"
        "${mainMod} SHIFT, 7, movetoworkspace, 7"
        "${mainMod} SHIFT, 8, movetoworkspace, 8"
        "${mainMod} SHIFT, 9, movetoworkspace, 9"
        "${mainMod} SHIFT, 0, movetoworkspace, 10"
        "${mainMod} SHIFT, KP_1, movetoworkspace, 1"
        "${mainMod} SHIFT, KP_2, movetoworkspace, 2"
        "${mainMod} SHIFT, KP_3, movetoworkspace, 3"
        "${mainMod} SHIFT, KP_4, movetoworkspace, 4"
        "${mainMod} SHIFT, KP_5, movetoworkspace, 5"
        "${mainMod} SHIFT, KP_6, movetoworkspace, 6"
        "${mainMod} SHIFT, KP_7, movetoworkspace, 7"
        "${mainMod} SHIFT, KP_8, movetoworkspace, 8"
        "${mainMod} SHIFT, KP_9, movetoworkspace, 9"
        "${mainMod} SHIFT, KP_0, movetoworkspace, 10"
        "${mainMod} SHIFT, comma, movecurrentworkspacetomonitor, l"
        "${mainMod} SHIFT, period, movecurrentworkspacetomonitor, r"
        "${mainMod}, S, togglespecialworkspace, magic"
        "${mainMod} SHIFT, S, movetoworkspace, special:magic"
        "${mainMod}, mouse_down, workspace, e+1"
        "${mainMod}, mouse_up, workspace, e-1"
      ];
      bindm = [
        "${mainMod}, mouse:272, movewindow"
        "${mainMod}, mouse:273, resizewindow"
      ];
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
      xwayland = {
        force_zero_scaling = true;
      };
    };

    xwayland.enable = true;
  };
}

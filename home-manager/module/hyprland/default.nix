{
  config,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:

let
  terminal = "kitty";
  zellij = "${terminal} --session ${../kitty/zellij.session}";
  quickie = "${terminal} --session ${../kitty/quickie.session}";
  fileManager = "pcmanfm";
  yazi = "${terminal} --session ${../kitty/yazi.session}";
  menu = "wofi --show drun";
  suspend = "systemctl suspend";
  setWallpaper = "systemctl --user start random-hyprpaper.service";
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

  home.sessionVariables.HYPRLAND_CONFIG = "${config.xdg.configHome}/hypr/hyprland.lua";

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgsUnstable.hyprland;
    configType = "lua";

    settings = {
      # Lua variables
      mainMod = {
        _var = "SUPER";
      };

      # Hyprland configuration
      config = {
        general = {
          gaps_in = 5;
          gaps_out = 7;
          border_size = 2;
          resize_on_border = true;
          layout = "master";
        };

        decoration = {
          rounding = 5;
          rounding_power = 2;
          inactive_opacity = 0.95;
        };

        animations = {
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
          new_status = "slave";
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          focus_on_activate = true;
        };

        input = {
          kb_model = "thinkpad";
          kb_layout = "no";
          kb_options = "caps:escape,numpad:mac";
          numlock_by_default = true;
          follow_mouse = 1;
          natural_scroll = true;

          touchpad = {
            clickfinger_behavior = 1;
            natural_scroll = true;
            disable_while_typing = true;
          };
        };
      };

      device = [
        {
          kb_model = "pc105";
          name = "gtips-reviung41";
          kb_layout = "us";
          kb_variant = "altgr-intl";
          kb_options = "nodeadkeys";
        }
        {
          kb_model = "pc105";
          name = "foostan-corne-v4-keyboard";
          kb_layout = "us";
          kb_variant = "altgr-intl";
          kb_options = "nodeadkeys";
        }
      ];

      # Key bindings
      bind = [
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + Q"'')
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${zellij}")'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + X"'')
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${quickie}")'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + C"'')
            (lib.generators.mkLuaInline "hl.dsp.window.close()")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + M"'')
            (lib.generators.mkLuaInline "hl.dsp.exit()")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + E"'')
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${fileManager}")'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + F"'')
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${yazi}")'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + V"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.float({ action = "toggle" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SPACE"'')
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${menu}")'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + L"'')
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${suspend}")'')
          ];
        }

        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + left"'')
            (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "left" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + right"'')
            (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "right" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + up"'')
            (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "up" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + down"'')
            (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "down" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + RETURN"'')
            (lib.generators.mkLuaInline ''hl.dsp.layout("swapwithmaster")'')
          ];
        }

        # Workspaces
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 1"'')
            (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "1" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 2"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '2' })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 3"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '3' })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 4"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '4' })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 5"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '5' })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 6"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '6' })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 7"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '7' })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 8"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '8' })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 9"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '9' })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 0"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '10' })")
          ];
        }

        # Move to workspace
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 1"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "1" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 2"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "2" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 3"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "3" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 4"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "4" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 5"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "5" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 6"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "6" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 7"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "7" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 8"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "8" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 9"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "9" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 0"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "10" })'')
          ];
        }

        # Keypad workspace selection
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + KP_1"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '1' })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + KP_2"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '2' })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + KP_3"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '3' })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + KP_4"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '4' })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + KP_5"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '5' })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + KP_6"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '6' })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + KP_7"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '7' })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + KP_8"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '8' })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + KP_9"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '9' })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + KP_0"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '10' })")
          ];
        }

        # Keypad move-to-workspace
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + KP_1"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "1" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + KP_2"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "2" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + KP_3"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "3" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + KP_4"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "4" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + KP_5"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "5" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + KP_6"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "6" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + KP_7"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "7" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + KP_8"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "8" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + KP_9"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "9" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + KP_0"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "10" })'')
          ];
        }

        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + comma"'')
            (lib.generators.mkLuaInline ''hl.dsp.workspace.move({ monitor = "l" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + period"'')
            (lib.generators.mkLuaInline ''hl.dsp.workspace.move({ monitor = "r" })'')
          ];
        }

        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + S"'')
            (lib.generators.mkLuaInline ''hl.dsp.workspace.toggle_special("magic")'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + S"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "special:magic" })'')
          ];
        }

        {
          _args = [
            "PRINT"
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("grimblast copysave area")'')
          ];
        }
        {
          _args = [
            "CTRL + PRINT"
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("grimblast edit area")'')
          ];
        }

        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + D"'')
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${setWallpaper}")'')
          ];
        }
      ];
    };
  };

  home.pointerCursor = {
    enable = true;

    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;

    hyprcursor = {
      enable = true;
    };
  };
}

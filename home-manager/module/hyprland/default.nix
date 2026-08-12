{
  config,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:

with lib;
with builtins;

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

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    extraConfig = readFile ./hyprland.lua;
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

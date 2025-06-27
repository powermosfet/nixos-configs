{ config, pkgs, ... }:

{
  imports = [
    ../waybar
    ../kanshi
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = builtins.readFile ./hyprland.conf;

    systemd.enable = true;
    xwayland.enable = true;
  };
}

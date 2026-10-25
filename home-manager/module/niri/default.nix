{
  config,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:

with lib;
with builtins;

{
  imports = [
    ../waybar
  ];

  wayland.windowManager.niri = {
    enable = false;
  };
}

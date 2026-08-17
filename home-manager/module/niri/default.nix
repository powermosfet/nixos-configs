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

  programs.niri.enable = true;
}

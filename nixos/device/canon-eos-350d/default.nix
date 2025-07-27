{
  pkgs,
  config,
  lib,
  ...
}:

with lib;

{
  services.udev.packages = [ pkgs.libgphoto2 ];
}

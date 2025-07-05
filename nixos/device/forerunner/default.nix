{
  pkgs,
  config,
  lib,
  ...
}:

with lib;

{
  config = {
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ACTION=="add", ENV{ID_VENDOR_ID}=="091e", ENV{ID_MODEL_ID}=="0f1d"
    '';
  };
}

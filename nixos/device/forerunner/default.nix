{
  pkgs,
  config,
  lib,
  ...
}:

with lib;

let
  dev = import ./device-name.nix;
in
{
  config = {
    services.udev.extraRules = ''
      SUBSYSTEM=="block", ENV{ID_VENDOR_ID}=="091e", ENV{ID_MODEL_ID}=="0f1d", ACTION=="add", TAG+="systemd", SYMLINK+="${dev}"
    '';
  };
}

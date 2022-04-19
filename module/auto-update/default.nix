{ pkgs, ... }:

{
    system.autoUpgrade = {
      enable = true;
      dates = "04:40";
      randomizedDelaySec = "45min";
      allowReboot = true;
    };
}




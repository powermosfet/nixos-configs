{ pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "no,us";
        variant = ",altgr-intl";
        options = "caps:escape,nodeadkeys";
      };

      xrandrHeads = [
        "DP-2-2"
        "DP-2-3"
        {
          output = "eDP-1";
          primary = true;
        }
      ];

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };
  };
}

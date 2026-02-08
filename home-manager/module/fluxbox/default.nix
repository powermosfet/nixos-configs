{ pkgs, ... }:

{
  home.packages = with pkgs; [
    crrcsim
    flightgear
  ];
  xsession.windowManager.fluxbox = {
    enable = true;
  };
}

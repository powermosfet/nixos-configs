{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    grimblast
    swappy
  ];

  home.sessionVariables = {
    GRIMBLAST_EDITOR = "swappy -f";
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/skjermbilder";
  };
}

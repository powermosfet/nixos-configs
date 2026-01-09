{ config, pkgs, ... }:

let
  dir = "${config.home.homeDirectory}/skjermbilder";
in
{
  home.packages = with pkgs; [
    grimblast
  ];

  home.sessionVariables = {
    GRIMBLAST_EDITOR = "swappy -f";
    XDG_SCREENSHOTS_DIR = dir;
  };

  programs.swappy = {
    enable = true;
    settings = {
      Default = {
        auto_save = true;
        line_size = 3;
        paint_mode = "rectangle";
        save_dir = dir;
        save_filename_format = "%Y%m%d-%H%M%S-swappy.png";
      };
    };
  };
}

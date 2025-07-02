{ config, pkgs, ... }:

{
  home.file = {
    ".config/kitty/zellij.session".source = ./zellij.session;
    ".config/kitty/quickie.session".source = ./quickie.session;
  };

  programs.kitty = {
    enable = true;

    settings = {
      font_size = 12.0;
      disable_ligatures = "cursor";
      confirm_os_window_close = 0;
    };
    font = {
      name = "FiraCode Nerd Font Mono";
      package = pkgs.nerd-fonts.fira-code;
      size = 16;
    };
  };
}

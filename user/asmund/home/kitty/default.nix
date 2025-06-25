{ config, pkgs, ... }:

{
  home.file = {
    ".config/kitty/kitty.conf".source = ./kitty.conf;
    ".config/kitty/zellij.session".source = ./zellij.session;
    ".config/kitty/quickie.session".source = ./quickie.session;
  };
}

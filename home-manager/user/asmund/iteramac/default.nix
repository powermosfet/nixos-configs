{ pkgs, ... }:

{
  imports = [
    ../../../module/zsh
    ../../../module/neovim
    ../../../module/yazi
    ../../../module/direnv
  ];

  programs.keepassxc.enable = true;
}

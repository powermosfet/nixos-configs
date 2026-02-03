{ pkgs, ... }:

{
  imports = [
    ../common.nix
    ../../../module/hyprland
    ../../../module/kitty
    ../../../module/mako
    ../../../module/satty
    ../../../module/bluetooth
    ../../../module/network
    ../../../module/random-background
    ../../../module/udiskie
    ../../../module/upload-forerunner
    ../../../module/nextcloud
    ../../../module/screenshot
    ../../../module/photo-archive
  ];

  home.packages = [ pkgs.libreoffice ];
}

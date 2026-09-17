{ pkgs, pkgsUnstable, ... }:

{
  home.packages = with pkgs; [
    pkgsUnstable.darktable
    gimp
    hugin
  ];
}

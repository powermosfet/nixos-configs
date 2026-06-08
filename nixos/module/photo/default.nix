{ pkgs, pkgsUnstable, ... }:

{
  environment.systemPackages = with pkgs; [
    pkgsUnstable.darktable
    gimp
    hugin
  ];
}

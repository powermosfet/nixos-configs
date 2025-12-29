{ pkgs, pkgsUnstable, ... }:

let
  pkgsUnstableWithOverlay = pkgsUnstable.extend (import ./lensfun-overlay.nix);
in
{
  imports = [
    ../../device/canon-eos-350d
  ];

  nixpkgs.overlays = [ (import ./lensfun-overlay.nix) ];

  environment.systemPackages = with pkgs; [
    pkgsUnstableWithOverlay.darktable
    gimp
    hugin
  ];
}

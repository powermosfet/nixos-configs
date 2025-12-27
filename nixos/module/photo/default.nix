{ pkgs, pkgsUnstable, ... }:

{
  imports = [
    ../../device/canon-eos-350d
  ];

  nixpkgs.overlays = [ (import ./lensfun-overlay.nix) ];

  environment.systemPackages = with pkgs; [
    pkgsUnstable.darktable
    gimp
    hugin
  ];
}

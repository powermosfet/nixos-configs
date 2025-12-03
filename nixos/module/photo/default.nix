{ pkgs, ... }:

{
  imports = [
    ../../device/canon-eos-350d
  ];

  # nixpkgs.overlays = [ (import ./lensfun-overlay.nix) ];

  environment.systemPackages = with pkgs; [
    darktable
    gimp
    rapid-photo-downloader
    hugin
  ];
}

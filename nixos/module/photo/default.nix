{ pkgs, ... }:

{
  imports = [
    ../../device/canon-eos-350d
  ];

  environment.systemPackages = with pkgs; [
    darktable
    gimp
  ];
}

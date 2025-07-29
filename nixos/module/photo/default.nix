{ pkgs, ... }:

{
  imports = [
    ../../device/canon-eos-350d
  ];

  environment.systemPackages = with pkgs; [
    darktable
    ansel
    gimp
  ];

  backup.paths = [ "/var/lib/syncthing/foto" ];
}

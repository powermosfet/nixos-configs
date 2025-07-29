{ ... }:

{
  imports = [
    ../borg
  ];

  backup.paths = [ "/var/lib/syncthing/foto" ];
}

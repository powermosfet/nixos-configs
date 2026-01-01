{
  config,
  pkgs,
  lib,
  ...
}:

let
  dir = "/home/asmund/foto/arkiv";
in
{
  home.packages = [ pkgs.sshfs ];

  systemd.user.services.sshfs-shared = {
    Unit = {
      Description = "SSHFS mount for photo archive";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "forking";
      ExecStart = ''
        ${lib.getExe pkgs.sshfs} mook.local:${dir} ${dir}
      '';
      ExecStop = "${pkgs.fuse}/bin/fusermount -u ${dir}";
      Restart = "on-failure";
      RestartSec = "10s";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}

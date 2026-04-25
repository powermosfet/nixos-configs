{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
with builtins;

let
  mookPorts = import ../../../../../machine/mook/ports.nix;
  strPort = toString mookPorts.exposed.pms;
in
{
  imports = [
    ../../../default.nix
  ];

  config = {
    services.borgbackup.jobs."gilli" = {
      paths = config.backup.paths;
      encryption.mode = "none";
      environment.BORG_RSH = "ssh -i /root/.ssh/id_borg-main-gilli";
      repo = "ssh://borg@gilli.local/./";
      compression = "auto,zstd";
      startAt = "05:00";
    };
    systemd.services = {
    "borgbackup-job-gilli" = {
      conflicts = config.backup.conflictingServices;
      postStop = concatStringsSep "\n" (
        map (service: "systemctl start " + service) config.backup.conflictingServices
      );
      onSuccess = [ "borgbackup-job-gilli-notify-success.service" ];
      onFailure = [ "notify-borg-home-failure.service" ];
    };
    "borgbackup-job-gilli-notify-success" = {
      description = "Notify borg-home backup success";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.curl}/bin/curl http://localhost:${strPort}/memo --json '{"subject":"Backup succeeded","content":"borgbackup-job-gilli"}'
          '';
      };
    };
    "borgbackup-job-gilli-notify-failure" = {
      description = "Notify borg-home backup failure";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.curl}/bin/curl http://localhost:${strPort}/memo --json '{"subject":"Backup failed","content":"borgbackup-job-gilli"}'
          '';
      };
    };
    };
  };
}


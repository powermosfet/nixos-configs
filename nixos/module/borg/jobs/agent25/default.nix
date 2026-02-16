{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
with builtins;

{
  imports = [
    ../../../tailscale
  ];

  config = {
    services.borgbackup.jobs."agent25" = {
      paths = config.backup.paths;
      encryption.mode = "keyfile";
      environment.BORG_RSH = "ssh -i /root/.ssh/id_borg-main-agent25";
      repo = "ssh://borg@agent25/./";
      compression = "auto,zstd";
      startAt = "04:00";
    };
    systemd.services."borgbackup-job-agent25" = {
      conflicts = config.backup.conflictingServices;
      postStop = concatStringsSep "\n" (
        map (service: "systemctl start " + service) config.backup.conflictingServices
      );
    };
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
with builtins;

{
  config = {
    services.borgbackup.jobs."gilli" = {
      paths = config.backup.paths;
      encryption.mode = "none";
      environment.BORG_RSH = "ssh -i /root/.ssh/id_borg-main-gilli";
      repo = "ssh://borg@gilli.local/./";
      compression = "auto,zstd";
      startAt = "05:00";
    };
    systemd.services."borgbackup-job-gilli" = {
      conflicts = config.backup.conflictingServices;
      postStop = concatStringsSep "\n" (
        map (service: "systemctl start " + service) config.backup.conflictingServices
      );
    };
  };
}

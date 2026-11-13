# Evaluate Wallabag together with zook's existing Borg jobs.
# Run with: nix-build nixos/module/wallabag/test.nix --no-out-link
{
  pkgs ? import <nixpkgs> { },
}:

let
  system = import (pkgs.path + "/nixos/lib/eval-config.nix") {
    inherit pkgs;
    modules = [
      ./default.nix
      ../borg/jobs/zook/agent25
      ../borg/jobs/zook/gilli
      {
        system.stateVersion = "25.11";
        backup.job.agent25.identityFile = "/run/keys/borg-agent25";
        backup.job.gilli.identityFile = "/run/keys/borg-gilli";
      }
    ];
  };
  cfg = system.config;
  expectedPaths = [
    cfg.services.wallabag.dataDir
    cfg.services.wallabag.backupDir
  ];
in
assert cfg.backup.paths == expectedPaths;
assert builtins.all
  (
    job:
    cfg.services.borgbackup.jobs.${job}.paths == expectedPaths
    && builtins.elem "phpfpm-wallabag.service" cfg.systemd.services."borgbackup-job-${job}".conflicts
  )
  [
    "agent25"
    "gilli"
  ];
pkgs.writeText "wallabag-backup-module-test" "Both zook Borg jobs include Wallabag state and pause application writes.\n"

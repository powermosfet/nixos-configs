{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
with builtins;

let
  job = "agent25";
  service = "borgbackup-job-${job}";
  onSuccessService = "${service}-notify-success";
  onFailureService = "${service}-notify-failure";
in
{
  imports = [

    (import ../../job.nix {
      job = "agent25";
      repo = "ssh://borg@agent25/./";
      encrypt = true;
      startAt = "04:00";
    })
    ../../../../tailscale
  ];
}

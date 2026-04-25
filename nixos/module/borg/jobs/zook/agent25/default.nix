{ ... }:

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

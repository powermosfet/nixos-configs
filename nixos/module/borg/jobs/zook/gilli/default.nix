{ ... }:

{
  imports = [
    (import ../../job.nix {
      job = "gilli";
      repo = "ssh://borg@gilli.local/./";
      encrypt = false;
      startAt = "05:00";
    })
  ];
}

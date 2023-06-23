{ pkgs }:

import ./helper {
  inherit pkgs;
  name = "sqlite";
  owner = "cosmocode";
  repo  = "sqlite";
  rev = "eec509745d8a5f8d6c03a0f831916e788feb3287";
  sha256 = "sha256-ALgpJIHwt8FfW1YWWTs7XRwDVrGEy+YwGA5kHQYNnGE=";
}

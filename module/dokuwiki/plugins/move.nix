{ pkgs }:

import ./helper {
  inherit pkgs;
  name = "move";
  owner = "michitux";
  repo  = "dokuwiki-plugin-move";
  rev = "6e56e1e81df72e6d8fe5a7092ae3dfe7d52fecbe";
  sha256 = "sha256-rQmbaRRFXoZhSPZnEYpiQ/sjGwp/Ij4Q9kCFWqbKLTY=";
}

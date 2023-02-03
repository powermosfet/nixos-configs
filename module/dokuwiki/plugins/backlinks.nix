{ pkgs }:

import ./helper {
  inherit pkgs;
  name = "backlinks";
  owner = "mprins";
  repo  = "dokuwiki-plugin-backlinks";
  rev = "d63ca3eba9ea7145a0fa1163931822267ec5b67d";
  sha256 = "CiZAEBB4XFCRI7P872AUdZHz6qcMr7x+nY+WK5WbSy8=";
}

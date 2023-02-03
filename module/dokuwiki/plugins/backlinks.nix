{ pkgs }:

import ./helper {
  inherit pkgs;
  name = "backlinks";
  owner = "mprins";
  repo  = "dokuwiki-plugin-backlinks";
  rev = "d63ca3eba9ea7145a0fa1163931822267ec5b67d";
  sha256 = "urXTsx7CtJHW577QfO3/C4sFpSoJM/7DT9ldZz51wmw=";
}

{ pkgs }:

import ./helper {
  inherit pkgs;
  name = "multiorphan";
  owner = "i-net-software";
  repo  = "dokuwiki-plugin-multiorphan";
  rev = "215d93e18e68cfc2fd4d72fa9de2f7267c697508";
  sha256 = "sha256-yXrTxfxvBe43lpHqa+XhQNRwbIpBGSx+V+n0n24EO/A=";
}

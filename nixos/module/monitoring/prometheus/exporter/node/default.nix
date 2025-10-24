{ config, pkgs, ... }:

let
  port = 9100;
in
{
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
    port = port;
    listenAddress = "0.0.0.0";
  };

  networking.firewall.allowedTCPPorts = [ port ];
}

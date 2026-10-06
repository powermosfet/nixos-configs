{ config, lib, ... }:

with lib;

let
  ip = config.services.dnsmasq.localip;
in
{
  imports = [
  ];
  options = {
    services.dnsmasq.localip = {
      zook = mkOption {
        type = types.str;
        description = "Ip address of zook";
      };
      mook = mkOption {
        type = types.str;
        description = "Ip address of mook";
      };
    };
  };

  config = {
    services.dnsmasq = {
      enable = true;
      settings = {
        server = [
          "84.234.191.26"
          "84.234.191.27"
        ];

        no-resolv = true;
        no-hosts = true;

        address = [
          "/sb.berge.id/${ip.zook}"
          "/bpd.home.arpa/${ip.mook}"
        ];

        interface = "enp0s25";
        bind-interfaces = true;
      };
    };

    networking.firewall.allowedUDPPorts = [ 53 ];
    networking.firewall.allowedTCPPorts = [ 53 ];
  };
}

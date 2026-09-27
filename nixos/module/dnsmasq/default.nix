{ ... }:

{
  imports = [
  ];
  options = {
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

        address = [ "/sb.berge.id/192.168.1.11" ];

        interface = "enp0s25";
        bind-interfaces = true;
      };
    };

    networking.firewall.allowedUDPPorts = [ 53 ];
    networking.firewall.allowedTCPPorts = [ 53 ];
  };
}

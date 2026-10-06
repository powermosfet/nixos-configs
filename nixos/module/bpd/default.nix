{ config, ... }:

with builtins;

let
  cfg = config.services.bpd;
  barcode-backend = config.services.barcode-backend;
in
{
  services.bpd = {
    enable = true;

    listenAddress = "127.0.0.1";
    productUrl = "http://localhost:${toString (barcode-backend.port)}/api/product";
    rabbitmq = {
      host = "localhost";
      queue = "missing-barcodes";
      shoppingListQueue = "shopping-list-items";
    };
  };
  services.nginx.virtualHosts."bpd.home.arpa" = {
    locations = {
      "/" = {
        proxyPass = "http://${cfg.listenAddress}:${toString (cfg.listenPort)}";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];
}

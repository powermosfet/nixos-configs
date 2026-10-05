{ config, ... }:

{
  services.bpd = {
    enable = true;

    listenAddress = "0.0.0.0";
    productUrl = "http://localhost:${builtins.toString (config.services.barcode-backend.port)}/api/product";
    rabbitmq = {
      host = "localhost";
      queue = "missing-barcodes";
    };
  };
}

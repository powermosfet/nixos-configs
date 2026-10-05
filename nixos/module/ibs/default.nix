{ config, lib, ... }:

{
  imports = [ ../../service/ibs ];

  services.ibs = {
    enable = true;
    settings = {
      PRODUCT_LOOKUP_URL_TEMPLATE = lib.mkDefault
        "http://127.0.0.1:${toString config.services.barcode-backend.port}/api/product/{barcode}";
      RABBITMQ_HOST = lib.mkDefault "localhost";
      RABBITMQ_PORT = lib.mkDefault (toString config.services.rabbitmq.port);
    };
  };

  systemd.services.ibs.after = [
    "rabbitmq.service"
    "barcode-backend.service"
  ];
}

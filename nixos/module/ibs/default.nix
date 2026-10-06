{ config, lib, ... }:

with lib;

{
  services.ibs = {
    enable = true;
    settings = {
      PRODUCT_LOOKUP_URL_TEMPLATE = mkDefault "http://127.0.0.1:${toString config.services.barcode-backend.port}/api/product/{barcode}";
      RABBITMQ_HOST = mkDefault "localhost";
      RABBITMQ_PORT = mkDefault (toString config.services.rabbitmq.port);
      BPD_URL = "http://bpd.home.arpa";
      PMS_HOST = "localhost";
      PMS_PORT = toString config.services.pms.port;
    };
  };

  systemd.services.ibs.after = [
    "rabbitmq.service"
    "barcode-backend.service"
  ];
}

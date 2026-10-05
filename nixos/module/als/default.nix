{ config, lib, ... }:

{
  imports = [ ../../service/als ];

  services.als = {
    enable = true;
    settings = {
      RABBITMQ_HOST = lib.mkDefault "localhost";
      RABBITMQ_PORT = lib.mkDefault (toString config.services.rabbitmq.port);
    };
  };

  systemd.services.als.after = [ "rabbitmq.service" ];
}

{ config, lib, ... }:

# Add the flake and import its nixos module to make this work
{
  services.als = {
    enable = true;
    rabbitmq = {
      host = "localhost";
      port = config.services.rabbitmq.port;
    };
  };

  systemd.services.als.after = [ "rabbitmq.service" ];
}

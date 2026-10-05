{ config, ... }:

let
  cfg = config.services.rabbitmq;
in
{
  services.rabbitmq = {
    enable = true;
    managementPlugin = {
      enable = true;
    };
    plugins = [
      "rabbitmq_mqtt"
    ];
    listenAddress = "0.0.0.0"; # remove if all clients turns out to be local
  };

  networking.firewall.allowedTCPPorts = [
    1883 # MQTT
    cfg.port # remove if all clients turns out to be local
  ];
}

{ ... }:

{
  networking.firewall.allowedTCPPorts = [ 1883 ]; # MQTT

  services.rabbitmq = {
    enable = true;
    managementPlugin = {
      enable = true;
    };
    plugins = [
      "rabbitmq_mqtt"
    ];
  };
}

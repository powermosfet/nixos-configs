{ ... }:

{
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

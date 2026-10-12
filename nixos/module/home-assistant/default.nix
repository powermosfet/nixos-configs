{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

{
  config = {
    services = {
      home-assistant = {
        enable = true;
        extraComponents = [
          "default_config"
          "met"
          "esphome"
          "mqtt"
          "mobile_app"
        ];
        config = {
          homeassistant = {
            name = "Berge";
            unit_system = "metric";
            time_zone = "Europe/Oslo";
          };
          mobile_app = { };
        };
        openFirewall = true;
      };
    };
  };
}

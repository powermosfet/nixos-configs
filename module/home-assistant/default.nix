{ config, pkgs, lib, ... }:

  with lib;

{
  config = {
    services = {
      home-assistant = {
        enable = true;
        config = {
          homeassistant = {
            name = "Berge";
            latitude = "!secret latitude";
            longitude = "!secret longitude";
            elevation = "!secret elevation";
            unit_system = "metric";
            time_zone = "Erope/Oslo";
          };
          frontend = {
            themes = "!include_dir_merge_named themes";
          };
          http = {};
          feedreader.urls = [ "https://nixos.org/blogs.xml" ];
        };
      };
    };
  };
}


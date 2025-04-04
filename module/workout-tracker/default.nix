{ pkgs, config, ... }:

let
  unstable = import <nixos-unstable> { };
in
{
  imports =
    [
    ];

  config = {
    services.workout-tracker = {
      enable = true;
      package = unstable.workout-tracker;
      
      settings = {
        WT_REGISTRATION_DISABLED = "true";
      };
    };

    services.nginx.virtualHosts."trening.berge.id" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${builtins.toString(config.services.workout-tracker.port)}";
          proxyWebsockets = true;
        };
      };
    };
  };
}

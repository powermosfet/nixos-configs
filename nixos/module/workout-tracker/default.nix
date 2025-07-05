{
  pkgs,
  pkgsUnstable,
  config,
  ...
}:

let
  hostname = import ./hostname.nix;
in
{
  config = {
    services.workout-tracker = {
      enable = true;
      package = pkgsUnstable.workout-tracker;

      settings = {
        WT_REGISTRATION_DISABLED = "true";
      };
    };

    services.nginx.virtualHosts."${hostname}" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${builtins.toString (config.services.workout-tracker.port)}";
          proxyWebsockets = true;
        };
      };
    };
  };
}

{ ... }:

{
  config = {
    services.prometheus = {
      scrapeConfigs = [
        {
          job_name = "gilli";
          static_configs = [
            {
              targets = [ "gilli.local:9100" ];
            }
          ];
        }
      ];
    };
  };
}

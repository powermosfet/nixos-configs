{ ... }:

{
  config = {
    services.prometheus = {
      scrapeConfigs = [
        {
          job_name = "mook";
          static_configs = [
            {
              targets = [ "localhost:9100" ];
            }
          ];
        }
      ];
    };
  };
}

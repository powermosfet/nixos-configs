{ ... }:

let
  hostname = "mon.berge.id";
in
{
  imports = [
    ./prometheus
    ./prometheus/exporter/node
  ];

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

    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 3000;
          domain = "localhost";
        };
      };

      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://localhost:9090";
            isDefault = true;
          }
        ];
      };
    };

    services.nginx.virtualHosts."${hostname}" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
      };
    };
    services.ddclient.domains = [ hostname ];
  };
}

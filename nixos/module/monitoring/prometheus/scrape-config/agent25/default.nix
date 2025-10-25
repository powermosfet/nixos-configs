{ config, ... }:

let
  tunnel-port = 9101;
  prometheus-port = 9100;
  local-opts = config.local.prometheus;
in
{
  options = {
    local.prometheus = {
      agent25-key-file = mkOption {
        type = types.str;
        description = "Path to the agent25 ssh key file";
      };
    };
  };

  config = {
    systemd.services.prometheus-tunnel-agent25 = {
      description = "Prometheus tunnel to agent25";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.openssh}/bin/ssh -N -L ${tunnel-port}:localhost:${prometheus-port} prometheus@agen25.berge.id -p 222 -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes -o ConnectTimeout=10 -i ${local-opts.agent25-key-file}";
        Restart = "always";
        RestartSec = "10s";

        User = "prometheus";

        StartLimitIntervalSec = 300;
        StartLimitBurst = 5;
      };
    };

    services.prometheus = {
      scrapeConfigs = [
        {
          job_name = "agent25";
          static_configs = [
            {
              targets = [ "localhost:9101" ];
            }
          ];
        }
      ];
    };
  };
}

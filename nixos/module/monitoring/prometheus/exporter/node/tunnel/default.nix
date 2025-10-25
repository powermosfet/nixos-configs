{ ... }:

{
  imports = [
  ];
  options = {
  };

  config = {
    systemd.services.prometheus-tunnel = {
      description = "Prometheus metrics tunnel";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.openssh}/bin/ssh -N -R 9101:localhost:9100 prometheus-tunnel@main-server.yourdomain.com -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -i /path/to/tunnel-key";
        Restart = "always";
        RestartSec = "10s";
      };
    };
  };
}

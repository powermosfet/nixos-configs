{ ... }:

let
  service = "reverse-ssh-tunnel";
  cfg = config.services."${service}";
  common = import ../common.nix;
in
{
  options = {
    services."${service}" = {
      mook-port = mkOption {
        description = "Network port";
        type = types.int;
      };

      mook-hostname = mkOption {
        description = "Hostname";
        type = types.str;
      };
    };
  };

  config = {
    # On the backup node
    systemd.services."${service}" = {
      description = "Reverse SSH tunnel to Mook";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = "backup-user"; # Change to your actual user
        Restart = "always";
        RestartSec = "10s";

        # ExitType = "cgroup" ensures systemd waits for SSH to fully exit
        ExitType = "cgroup";

        ExecStart = ''
          ${pkgs.openssh}/bin/ssh -N -T \
            -o ServerAliveInterval=60 \
            -o ServerAliveCountMax=3 \
            -o ExitOnForwardFailure=yes \
            -o StrictHostKeyChecking=accept-new \
            -p ${builtins.toString cfg.mook-port} \
            -R ${builtins.toString common.port}:localhost:22 \
            ${cfg.mook-hostname}
        '';
      };
    };
  };
}

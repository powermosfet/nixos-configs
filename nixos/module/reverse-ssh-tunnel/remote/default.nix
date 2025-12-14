{
  pkgs,
  config,
  lib,
  ...
}:

with lib;

let
  service = "reverse-ssh-tunnel";
  cfg = config.services."${service}";
  common = import ../common.nix;
  user = "tunnel-client";
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

      ssh-key = mkOption {
        description = "Path to the ssh identity key file";
        type = types.path;
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
          -i ${cfg.ssh-key} \
          -o ServerAliveInterval=60 \
          -o ServerAliveCountMax=3 \
          -o ExitOnForwardFailure=yes \
          -o StrictHostKeyChecking=accept-new \
          -p ${builtins.toString cfg.mook-port} \
          -R 22:localhost:${builtins.toString common.port} \
          ${common.user}@${cfg.mook-hostname}
        '';
      };
    };

    users.users."${user}" = {
      isSystemUser = true;
      group = user;
      home = "/var/lib/${user}";
      createHome = true;
    };

    users.groups."${user}" = { };
  };
}

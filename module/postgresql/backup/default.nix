{ pkgs, config, lib, ... }:

  with lib;

let
  systemdUnit = "copy-postgresql-backup";
  cfg = config.services.copyPostgresqlBackup;
in
{
  imports =
    [ ../../../user/backup
    ];

  options.services.copyPostgresqlBackup = {
    location = mkOption {
      description = "location for copied backup";
      default = "/var/backup/postgresql-copy";
      type = types.path;
    };
  };

  config = {
    services.postgresqlBackup = {
      enable = true;
      backupAll = true;
    };

    systemd.services."${systemdUnit}" = {
      description = "Copy postgresql backup to a location with more relaxed permissions.";
      serviceConfig = {
        Type = "oneshot";
      };
      startAt = "04:00:00";
      script = ''
        mkdir -p ${cfg.location}
        cp -uR ${config.services.postgresqlBackup.location}/* ${cfg.location}
        chown -R ${config.backup.user}:${config.backup.group} ${cfg.location}
        '';
    };
  };
}

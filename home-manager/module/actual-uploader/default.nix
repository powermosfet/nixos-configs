{
  pkgs,
  lib,
  config,
  actual-sparebank1,
  ...
}:

let
  script = lib.getExe actual-sparebank1.packages."x86_64-linux".default;
  unit = "actual-sparebank1-uploader";
  cfg = config.services.actual-sparebank1-uploader;
in
{
  options.services.actual-sparebank1-uploader = {
    environmentFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to environment file for actual-sparebank1";
    };
  };

  config = {
    systemd.user.services."${unit}" = {
      Unit = {
        Description = "Upload the latest transactions from Sparebank1 to Actual Budget";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${script} --days=7 import";
        EnvironmentFile = cfg.environmentFile;
      };
    };

    systemd.user.timers."${unit}" = {
      Unit.Description = "Periodically upload transactions to Actual Budget";
      Timer = {
        Unit = unit;
        OnCalendar = "0/3:00"; # Every 5 hours
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}

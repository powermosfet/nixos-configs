{ pkgs, config, ... }:

{
  services.borgbackup.jobs."nextcloud-gilli" = {
    paths = config.services.nextcloud.home;
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -i /root/.ssh/id_borg-nextcloud";
    repo = "ssh://borg@gilli.local//mnt/passport/borgbackup/nextcloud";
    compression = "auto,zstd";
  };
}


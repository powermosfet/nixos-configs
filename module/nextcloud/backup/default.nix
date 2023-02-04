{ pkgs, options, ... }:

{
  services.borgbackup.jobs."nextcloud-gilli" = {
    paths = options.services.nextcloud.home;
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -i /root/.ssh/id_borg-nextcloud";
    repo = "ssh://backup@gilli.local:/mnt/passport/borgbackup/nextcloud";
    compression = "auto,zstd";
  };
}


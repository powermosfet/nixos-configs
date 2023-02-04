{ pkgs, config, site, ... }:

{
  services.borgbackup.jobs."dokuwiki-gilli" = {
    paths = config.services.dokuwiki."${site}".stateDir;
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -i /root/.ssh/id_borg-main";
    repo = "borg@gilli.local:.";
    compression = "auto,zstd";
  };
}



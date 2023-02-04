{ pkgs, config, ... }:

{
  services.borgbackup.jobs = builtins.mapAttrs (site: _: 
  {
    paths = config.services.dokuwiki."${builtins.replaceStrings ["."] ["-"] site}".stateDir;
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -i /root/.ssh/id_borg-main";
    repo = "borg@gilli.local:.";
    compression = "auto,zstd";
  }) config.services.dokuwiki.sites;
}



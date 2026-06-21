{ pkgs, config, ... }:

let
  hostName = "cloud.berge.id";
  email = "little.tree8655@fastmail.com";
  dbName = "nextcloud";
  dbUser = "nextcloud";
in
{
  services.nginx.virtualHosts = {
    "${hostName}" = {
      forceSSL = true;
      enableACME = true;
    };
  };
  services.ddclient.domains = [
    hostName
  ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;
    hostName = hostName;
    https = true;
    configureRedis = true;
    maxUploadSize = "16G";
    extraAppsEnable = true;
    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit
        calendar
        contacts
        mail
        notes
        onlyoffice
        tasks
        memories
        deck
        ;
    };
    settings = {
      default_phone_region = "NO";
    };
    config = {
      dbtype = "pgsql";
      dbuser = dbUser;
      dbhost = "/run/postgresql";
      dbname = dbName;
      adminuser = "dadmin";
    };
  };

  users.users.nextcloud.extraGroups = [ "keys" ];

  services.postgresql = {
    enable = true;
    ensureDatabases = [ dbName ];
    ensureUsers = [
      {
        name = dbUser;
        ensureDBOwnership = true;
      }
    ];
  };
  services.postgresqlBackup.databases = [ dbName ];

  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  security.acme.defaults.email = email;

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  backup.paths = [ config.services.nextcloud.datadir ];
}

{ pkgs, config, ... }:

let
  hostName = "cloud.berge.id";
  # onlyOfficeHostName = "onlyoffice.berge.id";
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
    # "${onlyOfficeHostName}" = {
    #   forceSSL = true;
    #   enableACME = true;
    # };
  };
  services.ddclient.domains = [
    hostName
    # onlyOfficeHostName
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

  # services.onlyoffice = {
  #   enable = true;
  #   hostname = "${onlyOfficeHostName}";
  # };

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

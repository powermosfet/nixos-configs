{ pkgs, ... }:

let
  hostName = "cloud.berge.id";
  email = "asmund@berge.id";
  dbName = "nextcloud";
  dbUser = "nextcloud";
in
{
  imports =
    [ ./backup
    ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud25;
    hostName = hostName;
    https = true;
    enableBrokenCiphersForSSE = false;
    config = {
      dbtype = "pgsql";
      dbuser = dbUser;
      dbhost = "/run/postgresql";
      dbname = dbName;
      adminuser = "dadmin";
      defaultPhoneRegion = "NO";
    };
  };
  
  users.users.nextcloud.extraGroups = [ "keys" ];

  environment.systemPackages = with pkgs; [
    ocrmypdf
  ];

  services.postgresql = {
    enable = true;
    ensureDatabases = [ dbName ];
    ensureUsers = [
      { name = dbUser;
        ensurePermissions."DATABASE ${dbName}" = "ALL PRIVILEGES";
      }
    ];
  };
  services.postgresqlBackup.databases = [ dbName ];

  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  services.nginx.virtualHosts."${hostName}" = {
    forceSSL = true;
    enableACME = true;
  };
  services.ddclient.domains = [ hostName ];

  security.acme.defaults.email = email;
  
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

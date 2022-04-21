{ config, pkgs, ... }:

let
  hostName = "cloud.berge.id";
  email = "asmund@berge.id";
in
{
  services.nextcloud = {
    enable = true;
    hostName = hostName;
    https = true;
    config = {
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      dbname = "nextcloud";
      adminuser = "dadmin";
    };
  };
  
  users.users.nextcloud.extraGroups = [ "keys" ];

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      { name = "nextcloud";
        ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
      }
    ];
  };

  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  services.nginx.virtualHosts."${hostName}" = {
    forceSSL = true;
    enableACME = true;
  };

  security.acme.email = email;
  
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

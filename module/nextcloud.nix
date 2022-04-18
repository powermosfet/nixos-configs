{ config, pkgs, ... }:

let
  hostName = "cloud.berge.id";
  email = "asmund@berge.id";
in
{
  imports =
    [ 
    ];

  services.nextcloud = {
    enable = true;
    hostName = hostName;
    https = true;
    config = {
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      dbname = "nextcloud";
      adminpassFile = "/run/keys/nextcloud/admin-password";
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
}

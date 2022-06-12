{ pkgs, ... }:

let
  hostName = "cloud.berge.id";
  email = "asmund@berge.id";
  dbName = "nextcloud";
  dbUser = "nextcloud";
in
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud23;
    hostName = hostName;
    https = true;
    config = {
      dbtype = "pgsql";
      dbuser = dbUser;
      dbhost = "/run/postgresql";
      dbname = dbName;
      adminuser = "dadmin";
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

    locations."~ ^\\/nextcloud\\/(?:index|remote|public|cron|core\\/ajax\\/update|status|ocs\\/v[12]|updater\\/.+|oc[ms]-provider\\/.+|.+\\/richdocumentscode\\/proxy)\\.php(?:$|\\/)".extraConfig = ''
          include ${pkgs.nginx}/conf/fastcgi.conf;
          fastcgi_split_path_info ^(.+?\.php)(\\/.*)$;
          set $path_info $fastcgi_path_info;
          try_files $fastcgi_script_name =404;
          fastcgi_param PATH_INFO $path_info;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
          fastcgi_param HTTPS on;
          fastcgi_param modHeadersAvailable true;
          fastcgi_param front_controller_active true;
          fastcgi_pass unix:/run/phpfpm/nextcloud.sock;
          fastcgi_intercept_errors on;
          fastcgi_request_buffering off;
          fastcgi_read_timeout 120s;
      '';
  };

  security.acme.defaults.email = email;
  
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

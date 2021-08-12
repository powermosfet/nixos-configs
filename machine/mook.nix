{ config, pkgs, ... }:

{
  imports =
    [
    ];

  environment.systemPackages = with pkgs; [
    git
    neovim 
  ];

  services.openssh.enable = true;
  
  services.nginx.enable = false;

  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.local";
    config = {
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      dbname = "nextcloud";
      adminpassFile = "/run/keys/nextcloud-password";
      adminuser = "dadmin";
    };
  };
  
  users.extraUsers.nextcloud.extraGroups = [ "keys" ];

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

  services.phpfpm.pools.nextcloud.settings = {
    "listen.owner" = config.services.httpd.user;
    "listen.group" = config.services.httpd.group;
  };

  services.httpd = {
    enable = true;
    adminAddr = "webmaster@localhost";
    extraModules = [ "proxy_fcgi" ];

    virtualHosts."nextcloud.local" = {
      documentRoot = config.services.nextcloud.package;
      extraConfig = ''
        <Directory "${config.services.nextcloud.package}">
          <FilesMatch "\.php$">
            <If "-f %{REQUEST_FILENAME}">
              SetHandler "proxy:unix:${config.services.phpfpm.pools.nextcloud.socket}|fcgi://nextcloud.local/"
            </If>
          </FilesMatch>
          <IfModule mod_rewrite.c>
            RewriteEngine On
            RewriteBase /
            RewriteRule ^index\.php$ - [L]
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteCond %{REQUEST_FILENAME} !-d
            RewriteRule . /index.php [L]
          </IfModule>
          DirectoryIndex index.php
          Require all granted
          Options +FollowSymLinks
        </Directory>
      '';
    };

  };

  services.mediawiki = {
    enable = true;
    name = "Berge wiki";
    passwordFile = "/run/keys/mediawiki-password";
    database = {
      type = "mysql";
      createLocally = true;
    };
    virtualHost =  {
      hostName = "mediawiki.local";
      adminAddr = "webmaster@example.org";
      forceSSL = false;
      enableACME = false;
    };
  };

  
  services.parsoid = {
    enable = true;
    wikis = [ "http://localhost/api.php" ];
  };

  services.mysql = {
    enable = true;
  };

  services.mysqlBackup = {
    enable = true;
    databases = [ "mediawiki" ];
  };

  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
}


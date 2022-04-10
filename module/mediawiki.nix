
{ config, pkgs, ... }:

{
  imports =
    [ 
    ];

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
}

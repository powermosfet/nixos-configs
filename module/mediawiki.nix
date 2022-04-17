
{ config, pkgs, ... }:

{
  imports =
    [ 
    ];

  services.mediawiki = {
    enable = true;
    name = "Berge wiki";
    database = {
      type = "mysql";
      createLocally = true;
    };
    virtualHost =  {
      hostName = "wiki.berge.id";
      adminAddr = "asmund@berge.id";
      forceSSL = true;
      enableACME = true;
    };
    extensions = {
      ParserFunctions = null;
      CategoryTree = null;
    };
    extraConfig = ''
      $wgLanguageCode = 'no';
      '';
  };

  security.acme.certs = {
    "wiki.berge.id" = {
      email = "asmund@berge.id";
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

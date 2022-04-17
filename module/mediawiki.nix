
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
      VisualEditor = null;
    };
    extraConfig = ''
      $wgLanguageCode = 'no';
      $wgNamespacesWithSubpages[NS_MAIN] = 1;

      # Disable reading by anonymous users
      $wgGroupPermissions['*']['read'] = false;
      
      # Disable anonymous editing
      $wgGroupPermissions['*']['edit'] = false;
      
      # Prevent new user registrations except by sysops
      $wgGroupPermissions['*']['createaccount'] = false;

      $wgLogo = "$wgUploadPath/images/d/d4/Logo.jpg";
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

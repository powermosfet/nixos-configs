
{ config, pkgs, ... }:

let
  hostName = "wiki.berge.id";
  email = "asmund@berge.id";
in
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
      hostName = hostName;
      adminAddr = email;
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
    "${hostName}" = {
      email = email;
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


{ config, pkgs, ... }:

let
  hostName = "wiki.berge.id";
  email = "asmund@berge.id";
  internalPort = 8004;
in
{
  imports =
    [ 
    ];

  services.httpd.adminAddr = email;

  services.mediawiki = {
    enable = true;
    name = "Berge wiki";
    database = {
      type = "mysql";
      createLocally = true;
    };
    virtualHost = {
      hostName = hostName;
      adminAddr = email;
      listen =  [
        {
          ip = "127.0.0.1";
          port = internalPort;
          ssl = false;
        }
      ];
    };
    extensions = {
      ParserFunctions = null;
      CategoryTree = null;
      VisualEditor = null;
      WikiEditor = null;
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

  services.nginx.virtualHosts."${hostName}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString(internalPort)}";
      proxyWebsockets = true;
    };
  };

  security.acme.email = email;

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

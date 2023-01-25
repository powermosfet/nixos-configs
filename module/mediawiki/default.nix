
{ config, pkgs, lib, ... }:

  with lib;

let
  hostName = "wiki.berge.id";
  email = "asmund@berge.id";
  internalPort = config.services.mediawiki.internalPort;
  smtpPassword = config.services.mediawiki.smtpPassword;
in
{
  imports =
    [ ../../user/backup
    ];

  options = {
    services.mediawiki = {
      internalPort = mkOption {
        description = "internal network port used by reverse proxy";
        type = types.int;
      };
      smtpPassword = mkOption {
        description = "SMTP password";
        type = types.str;
      };
    };
  };

  config = {
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
        Cite = null;
        Diagrams = fetchTarball "https://github.com/samwilson/diagrams-extension/archive/refs/tags/0.11.0.tar.gz";
      };
      extraConfig = ''
        $wgLanguageCode = 'no';
        $wgNamespacesWithSubpages[NS_MAIN] = 1;
        $wgFavicon = "favicon.png";

        $wgSMTP = [
            'host'     => 'localhost',
            'IDHost'   => 'berge.id',
            'port'     => 1025,
            'auth'     => true,
            'username' => 'aberge',
            'password' => '${smtpPassword}'
        ];

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
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${builtins.toString(internalPort)}";
          proxyWebsockets = true;
        };
        "/favicon.png" = {
          root = ./.;
          tryFiles = "/berge-wiki.png =404";
        };
      };
    };
    services.ddclient.domains = [ hostName ];

    security.acme.defaults.email = email;

    services.parsoid = {
      enable = true;
      wikis = [ "http://localhost/api.php" ];
    };

    services.mysql = {
      enable = true;
    };

    services.mysqlBackup = {
      enable = true;
      user = "backup";
      databases = [ "mediawiki" ];
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}

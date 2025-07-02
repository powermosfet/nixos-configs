{ pkgs, ... }:

{
  imports = [
  ];

  options = {
  };

  config = {
    services.mastodon = {
      enable = true;

      smtp = {
        port = 587;
        createLocally = false;
        host = "smtp-relay.sendinblue.com";
        authenticate = true;
        user = "little.tree8655@fastmail.com";
        fromAddress = "little.tree8655@fastmail.com";
      };
      database = {
        createLocally = true;
      };
      localDomain = "mas.berge.id";
      elasticsearch.host = "localhost";
    };

    services.nginx.virtualHosts."mas.berge.id" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${builtins.toString (internalPort)}";
          proxyWebsockets = true;
        };
        "/favicon.png" = {
          root = ./.;
          tryFiles = "/berge-wiki.png =404";
        };
      };
    };
  };
}

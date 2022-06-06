{ pkgs, ... }:

{
  imports =
    [
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
        user = "asmund@berge.id";
        fromAddress = "asmund@berge.id";
      };
      database = {
        createLocally = true;
      };
      localDomain = "mas.berge.id";
      elasticsearch.host = "localhost";
      configureNginx = true;
    };
  };
}

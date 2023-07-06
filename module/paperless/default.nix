{ pkgs, config, ... }:

let
  hostName = "papir.berge.id";
  email = "asmund@berge.id";
in
{
  services.paperless = {
    enable = true;
    address = hostName;
    extraConfig = {
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_OCR_LANGUAGE = "nor+eng";
    };
  };

  services.nginx.virtualHosts."${hostName}" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString(config.services.paperless.port)}";
        proxyWebsockets = true;
      };
    };
  };
  security.acme.defaults.email = email;

  backup.paths = [ config.services.paperless.dataDir ];
}


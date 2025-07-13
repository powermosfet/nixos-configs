{
  config,
  ...
}:

let
  cfg = config.services.mealie;
  hostName = "mat.berge.id";
  dbName = "mealie";
  dbUser = "mealie";
in
{
  imports = [
    ../postgresql
  ];

  services.mealie = {
    enable = true;

    database.createLocally = true;
    settings = {
    };
  };

  services.nginx.virtualHosts."${hostName}" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString cfg.port}";
        proxyWebsockets = true;
      };
    };
  };
  services.ddclient.domains = [ hostName ];

  # services.postgresqlBackup.databases = [ dbName ];
}

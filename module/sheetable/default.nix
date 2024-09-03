{ config, pkgs, lib, ... }:

  with lib;
  with builtins;

let
  hostName = "noter.berge.id";
  email = "little.tree8655@fastmail.com";
  dbName = "sheetable";
  dbUser = "sheetable";
in
{
  imports =
    [ ../docker
      # ../postgresql
    ];

  config = {

    # services.nginx.virtualHosts."${hostName}" = {
    #   enableACME = true;
    #   forceSSL = true;
    #   locations = {
    #     "/" = {
    #       proxyPass = "http://127.0.0.1:${builtins.toString(config.services.paperless.port)}";
    #       proxyWebsockets = true;
    #     };
    #   };
    # };
    # security.acme.defaults.email = email;

    # services.postgresql = {
    #   ensureUsers = [
    #     {
    #       name = dbUser;
    #       ensureDBOwnership = true;
    #     }
    #   ];
    #   ensureDatabases = [
    #     dbName
    #   ];
    # };
    # services.postgresqlBackup.databases = [ dbName ];

    # backup.paths = [ config.services.paperless.dataDir ];

    virtualisation.oci-containers.containers."sheetable" = {
      autoStart = true;
      environment = {
      };
      image = "vallezw/sheetable";
      ports = [ "${builtins.toString(8999)}:8080" ];
    };

    networking.firewall.allowedTCPPorts = [ 8999 ];

  };
}

{ config, pkgs, ... }:

let
  hostName = "nure.berge.id";
in
{
  users.users.nure = {
    isNormalUser = true;
  };

  services.nginx.virtualHosts."${hostName}" = {
    enableACME = true;
    forceSSL = true;
    root = "/var/www/${hostName}";
  };
  services.ddclient.domains = [ hostName ];
}


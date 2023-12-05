{ pkgs, config, ... }:

let
  hostName = "wiki.berge.id";
  email = "asmund@berge.id";
in
{
  config = {
    services.trilium-server = {
      enable = true;
      nginx = {
        enable = true;
	hostName = hostName;
      };
      instanceName = "Berge Wiki";
      host = hostName;
    };

    services.nginx.virtualHosts."${hostName}" = {
      enableACME = true;
      forceSSL = true;
    };
    security.acme.defaults.email = email;

  };
}




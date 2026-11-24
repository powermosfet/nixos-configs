{ config, ... }:

let
  cfg = config.services.kavita;
  hostname = "bok.berge.id";
in
{
  imports = [
    ../acme
    ../tailscale
    ../borg/default.nix
  ];

  services.kavita = {
    enable = true;
    tokenKeyFile = "/var/lib/kavita-secrets/token-key";
    settings.IpAddresses = "127.0.0.1";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts.${hostname} = {
      onlySSL = true;
      enableACME = true;
      # Share Wallabag's Tailscale socket, never nginx's wildcard listeners.
      listen = [
        {
          addr = config.services.wallabag.listenAddress;
          port = 443;
          ssl = true;
        }
      ];
      extraConfig = ''
        allow 100.64.0.0/10;
        deny all;
      '';
      locations."/" = {
        proxyPass = "http://${cfg.settings.IpAddresses}:${toString cfg.settings.Port}";
        proxyWebsockets = true;
      };
    };
  };

  # zook already waits for this address through wallabag-network.service.
  security.acme.certs.${hostname} = {
    email = "little.tree8655@fastmail.com";
    dnsProvider = "cloudflare";
    environmentFile = "/var/lib/acme/cloudflare.env";
    dnsResolver = "1.1.1.1:53";
    webroot = null;
  };

  backup.paths = [
    cfg.dataDir
    "/var/lib/kavita-secrets"
  ];
  backup.conflictingServices = [ "kavita.service" ];
}

{ config, lib, ... }:

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

  options.services.kavita.libraryDir = lib.mkOption {
    type = lib.types.strMatching "/.+";
    description = "Absolute directory shared with Nextcloud as local external storage.";
  };

  config = {
    services.kavita = {
      enable = true;
      tokenKeyFile = "/var/lib/kavita-secrets/token-key";
      settings.IpAddresses = "127.0.0.1";
    };

    users.groups.kavita-library = { };
    users.users.${cfg.user}.extraGroups = [ "kavita-library" ];
    users.users.nextcloud.extraGroups = [ "kavita-library" ];

    # Default ACLs keep Nextcloud uploads readable by the shared group.
    systemd.tmpfiles.rules = [
      "d ${lib.escapeShellArg cfg.libraryDir} 2770 nextcloud kavita-library - -"
      "a+ ${lib.escapeShellArg cfg.libraryDir} - - - - d:u::rwx,d:g::rwx,d:m::rwx,d:o::---"
    ];
    systemd.services.kavita = {
      unitConfig.RequiresMountsFor = [ cfg.libraryDir ];
      serviceConfig.ReadOnlyPaths = [ cfg.libraryDir ];
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts.${hostname} = {
        onlySSL = true;
        enableACME = true;
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

    security.acme.certs.${hostname} = {
      email = "little.tree8655@fastmail.com";
      dnsProvider = "cloudflare";
      environmentFile = "/var/lib/acme/cloudflare.env";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
    };

    backup.paths = [
      cfg.dataDir
      cfg.libraryDir
      "/var/lib/kavita-secrets"
    ];
    backup.conflictingServices = [ "kavita.service" ];
  };
}

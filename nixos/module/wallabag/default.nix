{ config, pkgs, ... }:

let
  cfg = config.services.wallabag;
in
{
  imports = [
    ../../service/wallabag
    ../acme
    ../tailscale
    ../borg/default.nix
  ];

  services.wallabag = {
    enable = true;
    hostName = "les.berge.id";
    listenAddress = "100.119.101.124";
  };
  services.nginx.recommendedTlsSettings = true;
  security.acme.certs.${cfg.hostName} = {
    email = "little.tree8655@fastmail.com";
    dnsProvider = "cloudflare";
    environmentFile = "/var/lib/acme/cloudflare.env";
    dnsResolver = "1.1.1.1:53";
    webroot = null;
  };

  # A running tailscaled does not imply that its interface already has an IP.
  systemd.services.wallabag-network = {
    description = "Wait for Wallabag's Tailscale listener address";
    requires = [ "tailscaled.service" ];
    after = [ "tailscaled.service" ];
    before = [ "nginx.service" ];
    serviceConfig = {
      Type = "oneshot";
      TimeoutStartSec = 90;
    };
    script = ''
      for attempt in $(seq 1 60); do
        if ${pkgs.iproute2}/bin/ip -4 -o addr show dev tailscale0 | ${pkgs.gnugrep}/bin/grep -Fq ' ${cfg.listenAddress}/'; then
          exit 0
        fi
        sleep 1
      done
      echo "Tailscale address ${cfg.listenAddress} is unavailable" >&2
      exit 1
    '';
  };
  systemd.services.nginx = {
    requires = [ "wallabag-network.service" ];
    after = [ "wallabag-network.service" ];
  };
  # Existing tailscale0 trust and tailnet ACLs govern access; no global port opening.
  backup.paths = [
    cfg.dataDir
    cfg.backupDir
  ];
  backup.conflictingServices = [ "phpfpm-wallabag.service" ];
}

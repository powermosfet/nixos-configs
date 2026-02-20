{ config, pkgs, ... }:

let
  ports = import ./ports.nix;
in
{
  imports = [
    ../../user/asmund
    ../../user/nure
    ../../module/borg/jobs/mook/gilli
    ../../module/borg/jobs/mook/agent25
    ../../module/nginx
    ../../module/als
    ../../module/pms
    ../../module/postgresql
    ../../module/postgresql/backup
    ../../module/barcode-backend
    ../../module/nextcloud
    ../../module/node-red
    ../../module/avahi
    ../../module/ddclient
    ../../module/paperless
    ../../module/freshrss
    ../../module/soft-serve
    ../../module/workout-tracker
    ../../module/lubelogger
    ../../module/mealie
    ../../module/immich
    ../../module/photo/backup.nix
    ../../module/monitoring
    ../../module/budget
    ../../module/tailscale
  ];

  # Ports
  services.pms.port = ports.exposed.pms;
  services.als.port = ports.exposed.als;
  services.barcode-backend.port = ports.exposed.barcode;
  # services.onlyoffice.port = ports.internal.onlyoffice;
  services.workout-tracker.port = ports.internal.workout-tracker;
  services.tika.port = ports.internal.tika;
  services.gotenberg.port = ports.internal.gotenberg;
  services.mealie.port = ports.internal.mealie;
  services.cryptpad.settings.httpPort = ports.internal.cryptpad;
  services.cryptpad.settings.websocketPort = ports.internal.cryptpadWebsocket;
  services.actual.settings.port = ports.internal.actual;

  backup.paths = [ "/home/asmund/loftet" ];

  services.syncthing = {
    enable = true;
    user = "backup";
  };
  users.users.backup.extraGroups = [
    "nextcloud" # To get access to /var/lib/nextcloud/...
  ];

  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      PermitEmptyPasswords = false;
      X11Forwarding = false;
      AllowAgentForwarding = false;
      AllowTcpForwarding = "yes";
      MaxAuthTries = 3;
      LoginGraceTime = 20;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
    };
  };
  services.fail2ban.enable = true;

  security.sudo.wheelNeedsPassword = false;
}

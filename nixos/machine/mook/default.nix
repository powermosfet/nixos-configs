{ config, pkgs, ... }:

let
  ports = import ./ports.nix;
in
{
  imports = [
    ../../user/asmund
    ../../user/nure
    ../../module/borg/jobs/main
    ../../module/nginx
    ../../module/als
    ../../module/pms
    ../../module/postgresql
    ../../module/postgresql/backup
    ../../module/barcode-backend
    ../../module/nextcloud
    ../../module/node-red
    ../../module/avahi
    # ../../module/minecraft
    # ../../module/elasticsearch
    ../../module/ddclient
    ../../module/paperless
    ../../module/freshrss
    ../../module/soft-serve
    ../../module/workout-tracker
    ../../module/silverbullet
    ../../module/lubelogger
    ../../module/mealie
    ../../module/immich
  ];

  # Ports
  services.pms.port = ports.exposed.pms;
  services.als.port = ports.exposed.als;
  services.barcode-backend.port = ports.exposed.barcode;
  services.onlyoffice.port = ports.internal.onlyoffice;
  services.workout-tracker.port = ports.internal.workout-tracker;
  services.silverbullet.listenPort = ports.internal.silverbullet;
  services.paperless.tikaPort = ports.internal.tika;
  services.paperless.gotenbergPort = ports.internal.gotenberg;
  services.mealie.port = ports.internal.mealie;
  services.cryptpad.settings.httpPort = ports.internal.cryptpad;
  services.cryptpad.settings.websocketPort = ports.internal.cryptpadWebsocket;

  backup.paths = [ "/home/asmund/loftet" ];

  services.syncthing = {
    enable = true;
    user = "backup";
  };
  users.users.backup.extraGroups = [
    "nextcloud" # To get access to /var/lib/nextcloud/...
  ];

  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  networking.firewall.allowedTCPPorts = [ 22 ];
}

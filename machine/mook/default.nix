{ config, pkgs, ... }:

let
  ports = import ./ports.nix;
in
{
  imports =
    [ ../../user/asmund
      ../../module/borg/jobs/main
      ../../module/tmux 
      ../../module/nginx
      ../../module/als
      ../../module/pms
      ../../module/postgresql
      ../../module/postgresql/backup
      ../../module/barcode-backend
      ../../module/nextcloud
      ../../module/dokuwiki
      ../../module/node-red
      ../../module/avahi
      ../../module/neovim
      ../../module/minecraft
      ../../module/elasticsearch
      ../../module/smtp
      ../../module/bokashi
      ../../module/kilometer
      ../../module/ddclient
      ../../module/home-assistant
      ../../module/paperless
      ../../module/pgadmin
    ];

  services.pms.port = ports.exposed.pms;
  services.als.port = ports.exposed.als;
  services.barcode-backend.port = ports.exposed.barcode;

  environment.systemPackages = with pkgs; [
    git
  ];

  backup.paths = [ "/home/asmund/loftet" ];

  services.syncthing = {
    enable = true;
    user = "backup";
  };
  users.users.backup.extraGroups = 
    [ "nextcloud" # To get access to /var/lib/nextcloud/...
    ]; 

  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  networking.firewall.allowedTCPPorts = [ 22 ];
}


{ config, pkgs, ... }:

let
  ports = import ./ports.nix;
in
{
  imports =
    [ ../../user/asmund
      ../../module/tmux 
      ../../module/nginx
      ../../module/als
      ../../module/pms
      ../../module/postgresql
      ../../module/postgresql/backup
      ../../module/barcode-backend
      ../../module/nextcloud
      ../../module/mediawiki
      ../../module/avahi
      ../../module/neovim
      ../../module/minecraft
      ../../module/auto-update
      ../../module/garbage-collection
    ];

  services.mediawiki.internalPort = ports.internal.wiki;
  services.pms.port = ports.exposed.pms;
  services.als.port = ports.exposed.als;
  services.barcode-backend.port = ports.exposed.barcode;

  environment.systemPackages = with pkgs; [
    git
  ];

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


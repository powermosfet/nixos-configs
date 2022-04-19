{ config, pkgs, ... }:

let
  ports = import ./ports.nix;
in
{
  imports =
    [ ../../user/asmund.nix
      ../../module/tmux.nix 
      ../../module/nginx.nix
      ../../module/als
      ../../module/pms
      ../../module/postgresql
      ../../module/postgresql/backup
      ../../module/barcode-backend
      ../../module/nextcloud.nix
      ../../module/mediawiki.nix
      ../../module/avahi.nix
      ../../module/neovim
      ../../module/minecraft
      ../../module/auto-update.nix
      ../../module/garbage-collection.nix
    ];

  services.mediawiki.internalPort = ports.internal.wiki;
  services.pms.port = ports.exposed.pms;
  services.als.port = ports.exposed.als;
  services.barcode-backend.port = ports.exposed.barcode;

  environment.systemPackages = with pkgs; [
    git
  ];

  services.syncthing.enable = true;

  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  networking.firewall.allowedTCPPorts = [ 22 ];
}


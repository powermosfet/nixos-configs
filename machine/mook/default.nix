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
      ../../module/mediawiki.nix
      ../../module/nextcloud.nix
      ../../module/avahi.nix
      ../../module/neovim
      ../../module/auto-update.nix
      ../../module/garbage-collection.nix
    ];

  services.mediawiki.internalPort = ports.internal.wiki;
  services.pms.port = ports.exposed.pms;

  environment.systemPackages = with pkgs; [
    git
  ];

  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  networking.firewall.allowedTCPPorts = [ 22 ];
}


{ config, pkgs, ... }:

{
  imports =
    [ ../module/als
      ../module/mediawiki.nix
      ../module/avahi.nix
      ../module/neovim
    ];

  environment.systemPackages = with pkgs; [
    git
  ];

  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
}


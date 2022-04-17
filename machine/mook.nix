{ config, pkgs, ... }:

{
  imports =
    [ ../user/asmund.nix
      ../module/als
      ../module/mediawiki.nix
      ../module/avahi.nix
      ../module/neovim
    ];

  environment.systemPackages = with pkgs; [
    git
  ];

  services.openssh.enable = true;
  
  security.sudo.wheelNeedsPassword = false;

  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
}


{ pkgs, ... }:

{
  imports =
    [ ../user/asmund.nix
      ../module/tmux.nix 
      ../module/neovim
      ../module/avahi.nix
      ../module/garbage-collection.nix
      ../module/auto-update.nix
    ];
     
  time.timeZone = "Europe/Oslo";

  networking.hostName = "gilli";
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    git
  ];
  
  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  services.syncthing.enable = true;
}


{ pkgs, ... }:

{
  imports =
    [ ../user/asmund.nix
      ../software/tmux.nix 
      ../software/neovim.nix
      ../software/avahi.nix
    ];
     
  time.timeZone = "Europe/Oslo";

  networking.hostName = "gilli";
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    git
  ];

  services = {
    syncthing = {
      enable = true;
    };
  };
}


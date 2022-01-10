{ pkgs, ... }:

{
  imports =
    [ ../user/asmund.nix
      ../software/tmux.nix 
      ../software/neovim.nix
    ];
     
  time.timeZone = "Europe/Oslo";

  networking.hostName = "gilli";
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    acpi
    usbutils
    pciutils
    vifm-full
  ];

  services = {
    syncthing = {
      enable = true;
    };
  };
}


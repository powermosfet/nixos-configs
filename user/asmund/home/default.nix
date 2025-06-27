{ config, pkgs, ... }:

{
  imports = [
    ./hyprland
    ./kitty
    ./flameshot
    ./bluetooth
    ./network
    ./activitywatch
    ./random-background
  ];

  home.username = "asmund";
  home.homeDirectory = "/home/asmund";

  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;
    };
  };
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  services.mako = {
    enable = true;

    settings = {
      default-timeout = 5000;
    };
  };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      # Add any custom bash configuration here
    '';
  };
}

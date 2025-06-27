{ config, pkgs, ... }:

{
  imports = [
    ./home/kitty
    ./home/flameshot
    ./home/waybar
    ./home/kanshi
    ./home/bluetooth
    ./home/network
    ./home/activitywatch
  ];

  home.username = "asmund";
  home.homeDirectory = "/home/asmund";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
  ];

  home.file = {
    ".config/hypr/hyprland.conf".source = ./home/hyprland/hyprland.conf;
  };

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

{ pkgs, ... }:

{
  security.polkit.enable = true;

  services = {
    displayManager.ly.enable = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wofi
    libsForQt5.dolphin
    networkmanagerapplet
    playerctl
    wl-clipboard
    hyprlandPlugins.hyprexpo
  ];
}

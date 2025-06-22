{ pkgs, ... }:

{
  security.polkit.enable = true;

  services = {
    displayManager.ly.enable = true;
  };

  programs.hyprland = {
    # Install the packages from nixpkgs
    enable = true;
    # Whether to enable XWayland
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wofi
    libsForQt5.dolphin
    networkmanagerapplet
    waybar
    hyprpaper
    playerctl
  ];
}

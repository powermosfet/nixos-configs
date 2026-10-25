{ pkgs, ... }:

{
  security.polkit.enable = true;

  services = {
    displayManager.gdm = {
      enable = true;
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };
  programs.niri.enable = true;
  programs.uwsm.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    wofi
    networkmanagerapplet
    playerctl
    wl-clipboard
  ];
}

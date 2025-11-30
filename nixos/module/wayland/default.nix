{ pkgs, ... }:

{
  security.polkit.enable = true;

  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };
  programs.uwsm.enable = true;

  environment.systemPackages = with pkgs; [
    wofi
    networkmanagerapplet
    playerctl
    wl-clipboard
    hyprlandPlugins.hyprexpo
  ];
}

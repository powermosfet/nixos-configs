{ pkgs, ... }:

{
  imports =
    [
    ];

  environment.systemPackages = with pkgs; [
    paprefs
    pasystray
    pavucontrol
  ];

  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
  };
}

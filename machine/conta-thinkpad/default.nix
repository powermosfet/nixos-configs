{ pkgs, pkgsUnstable, ... }:

let
  azure = pkgs.stdenv.mkDerivation {
    name = "azure";
    propagatedBuildInputs = [
      (pkgs.python3.withPackages (
        pythonPackages: with pythonPackages; [
          requests2
        ]
      ))
    ];
    dontUnpack = true;
    installPhase = "install -Dm755 ${./script/azure.py} $out/bin/az";
  };

in
{
  imports = [
    ../../module/wayland
    ../../user/asmund
    ../../module/neovim
    ../../module/avahi
    ../../module/printing
    ../../module/gnupg
    ../../module/docker
  ];

  time.timeZone = "Europe/Oslo";

  networking = {
    networkmanager.enable = true;

    extraHosts = ''
      127.0.0.1 conta.test
      127.0.0.1 app.conta.test
      127.0.0.1 api.conta.test
      127.0.0.1 gjest.conta.test
    '';
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    firefox
    kitty
    acpi
    brightnessctl
    pcmanfm
    keepassxc
    networkmanager
    usbutils
    pciutils
    libinput
    signal-desktop-bin
    flameshot
    evince
    mime-types
    spotify
    chromium
    pkgsUnstable.logseq
    alsa-utils
    pavucontrol
    shared-mime-info
    activitywatch
    slack
    mako
    vivaldi
    chromium
    gnome-icon-theme
    azure
  ];

  programs = {
    direnv = {
      enable = true;
    };
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.droid-sans-mono
    ];
  };

  xdg.mime = {
    enable = true;

    defaultApplications = {
      "application/pdf" = "evince.desktop";
    };
  };

  programs = {
    nm-applet.enable = true;
  };

  services = {
    logind.extraConfig = ''
      HandlePowerKey=suspend
    '';

    physlock = {
      enable = true;
      lockMessage = " 64K RAM SYSTEM  38911 BASIC BYTES FREE";
    };

    blueman.enable = true;

    syncthing = {
      enable = true;
      user = "asmund";
      dataDir = "/home/asmund/";
    };
  };

  services.dbus.enable = true;
  services.udisks2.enable = true;
  hardware.bluetooth.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  services.pipewire.wireplumber = {
    enable = true;
  };
}

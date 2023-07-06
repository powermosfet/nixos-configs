{ pkgs, ... }:

let
  unstable = import <nixos-unstable> { };
in
{
  imports =
    [ ../../user/asmund
      ../../module/tmux
      ../../module/neovim
      ../../module/avahi
      ../../module/games
      ../../module/scanner
      ../../module/printing
      ../../module/gnupg
      ../../module/rtl-sdr
    ];
     
  time.timeZone = "Europe/Oslo";

  networking.hostName = "asmund-thinkpad"; # Define your hostname.
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    firefox
    kitty
    acpi
    brightnessctl
    arandr
    pcmanfm
    keepassxc
    rofi
    polybar
    dbus
    networkmanager
    xorg.xev
    usbutils
    pciutils
    libinput
    signal-desktop
    flameshot
    gxkb
    vifm-full
    evince
    nextcloud-client
    mime-types
    spotify
    chromium
    unstable.logseq
  ];

  fonts.fonts = with pkgs; [
    nerdfonts
  ];


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
    xserver = {
      enable = true;
      layout = "no,us";
      xkbVariant = ",altgr-intl";
      xkbOptions = "caps:escape,nodeadkeys";

      xrandrHeads = [
        "DP-2-2"
        "DP-2-3"
        {
          output = "eDP-1";
          primary = true;
        }
      ];

      libinput = {
        enable = true;

        mouse = {
          naturalScrolling = true;
        };

        touchpad = {
          disableWhileTyping = true;
          tapping = false;
          scrollMethod = "twofinger";
          naturalScrolling = true;
          clickMethod = "clickfinger";
        };
      };

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };
    xrdp = {
      enable = true;
      defaultWindowManager = "xmonad";
      openFirewall = true;
    };

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
  services.printing.enable = true;
  hardware.bluetooth.enable = true;
}


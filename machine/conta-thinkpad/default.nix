{ pkgs, ... }:

let
  unstable = import <nixos-unstable> { };
in
{
  imports = [
    ../../user/asmund
    ../../module/neovim
    ../../module/avahi
    ../../module/printing
    ../../module/gnupg
  ];

  time.timeZone = "Europe/Oslo";

  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

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
    yazi
    evince
    mime-types
    spotify
    chromium
    unstable.logseq
    alsa-utils
    pavucontrol
    shared-mime-info
    activitywatch
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
    xserver = {
      enable = true;
      xkb = {
        layout = "no,us";
        variant = ",altgr-intl";
        options = "caps:escape,nodeadkeys";
      };

      xrandrHeads = [
        "DP-2-2"
        "DP-2-3"
        {
          output = "eDP-1";
          primary = true;
        }
      ];

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };

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
  hardware.bluetooth.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}

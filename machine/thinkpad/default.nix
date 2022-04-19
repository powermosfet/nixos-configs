{ pkgs, ... }:

{
  imports =
    [ ../../user/asmund
      ../../module/tmux
      ../../module/neovim
      ../../module/avahi
      ../../module/games
      ../../module/scanner
      ../../module/printing
      ../../module/pulseaudio
      ../../module/pro-audio
    ];
     
  nixpkgs.overlays = [
    (self: super:
      { xmonad = super.xmonad_0_17_0;
        xmonad-contrib = super.xmonad-contrib_0_17_0;
        xmonad-extra = super.xmonad-extra_0_17_0;
      }
    )
  ];

  time.timeZone = "Europe/Oslo";

  networking.hostName = "asmund-thinkpad"; # Define your hostname.
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    firefox
    kitty
    fira-code
    acpi
    brightnessctl
    arandr
    pcmanfm
    keepassxc
    rofi
    xmobar
    trayer
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
  ];

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


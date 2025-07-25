{ pkgs, pkgsUnstable, ... }:

{
  imports = [
    ../../module/wayland
    ../../user/asmund
    ../../device/reviung41
    ../../device/kinesis
    ../../module/avahi
    ../../module/scanner
    ../../module/printing
    ../../module/gnupg
    ../../module/pro-audio
    ../../device/forerunner
  ];

  time.timeZone = "Europe/Oslo";

  networking.hostName = "asmund-thinkpad"; # Define your hostname.
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
    gxkb
    vifm-full
    evince
    mime-types
    spotify
    chromium
    pkgsUnstable.logseq
    signal-desktop-bin
    alsa-utils
    timeline
    pavucontrol
    shared-mime-info
    kickstart
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

  services = {
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
  services.printing.enable = true;
  hardware.bluetooth.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.udev.extraRules = ''
    KERNEL=="ttyUSB0", MODE:="666"
  '';
}

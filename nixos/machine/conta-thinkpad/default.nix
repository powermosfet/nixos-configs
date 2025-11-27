{ pkgs, pkgsUnstable, ... }:

{
  imports = [
    ../../module/laptop
    ../../module/wayland
    ../../user/asmund
    ../../device/reviung41
    ../../device/kinesis
    ../../device/corne
    ../../module/avahi
    ../../module/printing
    ../../module/gnupg
    ../../module/docker
    ../../module/photo
  ];

  time.timeZone = "Europe/Oslo";

  networking = {
    networkmanager.enable = true;

    extraHosts = ''
      127.0.0.1 conta.test
      127.0.0.1 app.conta.test
      127.0.0.1 api.conta.test
      127.0.0.1 gjest.conta.test
      127.0.0.1 mysql.conta.test
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
    evince
    mime-types
    spotify
    chromium
    pkgsUnstable.logseq
    alsa-utils
    pavucontrol
    shared-mime-info
    slack
    mako
    vivaldi
    chromium
    gnome-icon-theme
    (import ./script/azure { pkgs = pkgs; })
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
    logind.extraConfig = ''
      HandlePowerKey=hibernate
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

{ config, pkgs, ... }:

{
  imports = [
    ./home/kitty
  ];

  home.username = "asmund";
  home.homeDirectory = "/home/asmund";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
  ];

  home.file = {
    ".config/hypr/hyprland.conf".source = ./home/hyprland/hyprland.conf;
  };

  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";

    settings = [
      {
        profile.name = "conta-undocked";
        profile.outputs = [
          {
            criteria = "AU Optronics 0x1EAC";
            mode = "1920x1200";
            scale = 1.0;
          }
        ];
      }
      {
        profile.name = "conta-home-office";
        profile.outputs = [
          {
            criteria = "Lenovo Group Limited LEN P27h-10 0x01010101";
            mode = "2560x1440";
            scale = 1.0;
            position = "0,0";
          }
          {
            criteria = "AU Optronics 0x1EAC";
            mode = "1920x1200";
            scale = 1.5;
            position = "-1280,0"; # 1920 / 1.5 = 1280.0
          }
        ];
      }
    ];
  };

  services.mako = {
    enable = true;

    settings = {
      default-timeout = 5000;
    };
  };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      # Add any custom bash configuration here
    '';
  };
}

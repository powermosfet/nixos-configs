{ config, pkgs, ... }:

{
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
    ".config/kitty/kitty.conf".source = ./home/kitty/kitty.conf;
    ".config/kitty/zellij.session".source = ./home/kitty/zellij.session;
    ".config/kitty/quickie.session".source = ./home/kitty/quickie.session;
  };

  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";

    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            mode = "1920x1200";
            scale = 1;
          }
        ];
      }
      {
        profile.name = "home-office";
        profile.outputs = [
          {
            criteria = "Lenovo Group Limited LEN P27h-10 0x01010101";
            mode = "2560x1440";
            scale = 1;
            position = "0,0";
          }
          {
            criteria = "eDP-1";
            mode = "1920x1200";
            scale = 1;
            position = "-1920,0";
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

{ ... }:

{
  imports = [
    ../../module/bash
    ../../module/neovim
    ../../module/yazi
    ../../module/direnv
  ];

  config = {
    home.username = "asmund";
    home.homeDirectory = "/home/asmund";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    home.stateVersion = "24.05"; # Please read the comment before changing.

    programs.home-manager.enable = true;
  };
}

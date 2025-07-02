{ config, pkgs, ... }:

{
  home.file = {
    ".config/nvim/snippets/package.json".source = ./snippet/package.json;
    ".config/nvim/snippets/javascript.json".source = ./snippet/javascript.json;
    ".config/nvim/snippets/all.json".source = ./snippet/all.json;
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;

    extraConfig = ''
      set runtimepath^=${./config}
    '';
    extraLuaConfig = ''
      require("sharedconfig.init")
    '';
    plugins = (import ./plugins.nix { pkgs = pkgs; }).plugins;
  };
}

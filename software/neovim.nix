
{ config, pkgs, ... }:

{
  imports =
    [
    ];

  environment.systemPackages = with pkgs; [
    ripgrep
  ];

  programs.neovim = {
    enable = true;

    vimAlias = true;
    viAlias = true;
    defaultEditor = true;

    configure = {
      customRC = ''
        lua << EOF
          ${pkgs.lib.readFile ./neovim/init.lua}
        EOF
      '';

      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          nerdtree
          fugitive
          vim-unimpaired
          surround
          vim-ragtag
          vim-speeddating
          vim-dispatch-neovim
          sleuth
          vim-bookmarks
          ultisnips
          telescope-nvim
          nvim-lspconfig
          vim-nix
          awesome-vim-colorschemes
          nvim-web-devicons
          barbar-nvim
        ];
      };
    };
  };
}

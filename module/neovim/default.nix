
{ config, pkgs, ... }:

{
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
          ${pkgs.lib.readFile ./init.lua}
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
          vim-dispatch
          sleuth
          vim-bookmarks
          ultisnips
          telescope-nvim
          nvim-lspconfig
          vim-nix
          awesome-vim-colorschemes
          gruvbox-nvim
          lsp-colors-nvim
          nvim-web-devicons
          barbar-nvim
          nvim-cmp
          cmp-nvim-ultisnips
          cmp-nvim-lsp
          cmp-path
          cmp-buffer
          dressing-nvim
        ];
      };
    };
  };
}

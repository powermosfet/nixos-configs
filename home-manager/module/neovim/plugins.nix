{ pkgs, ... }:

{
  plugins =
    let
      nvim-treesitter-with-plugins = pkgs.vimPlugins.nvim-treesitter.withPlugins (
        treesitter-plugins: with treesitter-plugins; [
          bash
          lua
          nix
          python
          elm
          php
          yaml
          ledger
          haskell
          gleam
        ]
      );
    in
    with pkgs.vimPlugins;
    [
      nvim-lspconfig
      nvim-treesitter-with-plugins
      plenary-nvim
      gruvbox-material
      mini-nvim
      vim-fugitive
      telescope-nvim
      telescope_hoogle
      {
        plugin = blink-cmp;
        type = "lua";
        config = ''
          require 'blink-cmp'.setup { }
        '';
      }
      nvim-web-devicons
      awesome-vim-colorschemes
      barbar-nvim
      neo-tree-nvim
      nvim-config-local
      vim-dispatch
      vim-dispatch-neovim
      unimpaired-nvim
      vim-eunuch
      vim-sleuth
      vim-surround
    ];
}

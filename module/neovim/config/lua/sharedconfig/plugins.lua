return require('packer').startup(function(use)
  use {
    'nvim-tree/nvim-tree.lua',
    requires = 'nvim-tree/nvim-web-devicons',
  }
  use 'tpope/vim-dispatch'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-ragtag'
  use 'tpope/vim-speeddating'
  use 'tpope/vim-sleuth'
  use 'MattesGroeger/vim-bookmarks'
  use 'SirVer/ultisnips'
  use {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
    'tom-anders/telescope-vim-bookmarks.nvim',
    requires = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension('vim_bookmarks')
    end
  }
  use 'neovim/nvim-lspconfig'
  use {
    'akinsho/bufferline.nvim',
    tag = "v3.*",
    requires = 'nvim-tree/nvim-web-devicons'
  }
  use 'airblade/vim-gitgutter'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'quangnguyen30192/cmp-nvim-ultisnips'
  use 'MunifTanjim/exrc.nvim'
  use 'MunifTanjim/nui.nvim'
  use 'stevearc/dressing.nvim'
  use 'flazz/vim-colorschemes'

  use {
    'purescript-contrib/purescript-vim',
    ft = {'purescript', 'purs'},
  }

end)


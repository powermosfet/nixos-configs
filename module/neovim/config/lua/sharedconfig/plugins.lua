return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
    'nvim-tree/nvim-tree.lua',
    requires = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("nvim-tree").setup()
    end,
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
  use {
    'SirVer/ultisnips',
    config = [[
      vim.g.UltiSnipsExpandTrigger = "<tab>"
      vim.g.UltiSnipsJumpForwardTrigger = "<c-n>"
      vim.g.UltiSnipsJumpBackwardTrigger = "<c-p>"
      vim.g.UltiSnipsEditSplit = 'vertical'
      vim.g.UltiSnipsRemoveSelectModeMappings = 0
    ]]
  }
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
    'romgrk/barbar.nvim',
    requires = 'nvim-tree/nvim-web-devicons'
  }
  use {
    'airblade/vim-gitgutter', 
    branch = 'main'
  }
  use {
    'hrsh7th/nvim-cmp',
    config = function()
      require('sharedconfig.plugins.cmp')
    end
  }
  use 'hrsh7th/cmp-nvim-lsp'
  use 'quangnguyen30192/cmp-nvim-ultisnips'
  use {
    'MunifTanjim/exrc.nvim',
    config = function()
      vim.o.exrc = false
      require("exrc").setup({
        files = {
          ".nvimrc.lua",
          ".nvimrc",
          ".exrc.lua",
          ".exrc",
        },
      })
    end
  }
  use 'MunifTanjim/nui.nvim'
  use 'stevearc/dressing.nvim'
  use 'flazz/vim-colorschemes'
  use { 
    'nvim-treesitter/nvim-treesitter', 
    run = ':TSUpdate',
    config = function()
      vim.env.CC = ''
      require'nvim-treesitter.configs'.setup {
        auto_install = true,
        ignore_install = {},

        highlight = {
          enable = true,
        },
      }
    end
  }
  use { 
    'nvim-treesitter/nvim-treesitter-textobjects', 
    config = function()
      require'nvim-treesitter.configs'.setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ai"] = "@parameter.inner",
            },
            selection_modes = {
              ['@function.outer'] = 'V', -- linewise
            },
            include_surrounding_whitespace = false,
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        }
      }
    end
  }
  use {
    'vimwiki/vimwiki',
    config = function()
      require('sharedconfig.plugins.vimwiki')
    end
  }
  use {
    'ElPiloto/telescope-vimwiki.nvim',
    config = function()
      require('sharedconfig.plugins.telescope.vimwiki')
    end
  }

  use {
    'purescript-contrib/purescript-vim',
    ft = {'purescript', 'purs'},
  }
  use {
    'sersorrel/vim-lilypond',
    ft = {'lilypond'},
  }
  use 'mattn/calendar-vim'
  use {
    'NeogitOrg/neogit',
    requires = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim', 'nvim-telescope/telescope.nvim' },
    config = function()
      require('neogit').setup {}
    end
  }

end)


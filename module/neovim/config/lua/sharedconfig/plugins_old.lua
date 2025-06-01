return {
  -- the colorscheme should be available when starting Neovim
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  { 'flazz/vim-colorschemes' },
  {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      ---@type snacks.Config
      opts = {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
          bigfile = { enabled = true },
          dashboard = { enabled = true },
          explorer = { enabled = true },
          indent = { enabled = true },
          input = { enabled = true },
          picker = { enabled = true },
          notifier = { enabled = true },
          quickfile = { enabled = true },
          scope = { enabled = true },
          scroll = { enabled = true },
          statuscolumn = { enabled = true },
          words = { enabled = true },
      },
  },
  {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      lazy = false,
      dependencies = {
          "nvim-tree/nvim-web-devicons",
      },
      opts = { }
  },
  { 'tpope/vim-dispatch' },
  { 'tpope/vim-eunuch' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-unimpaired' },
  { 'tpope/vim-ragtag' },
  { 'tpope/vim-speeddating' },
  { 'tpope/vim-sleuth' },
  { 'MattesGroeger/vim-bookmarks' },
  {
    'SirVer/ultisnips',
    config = [[
      vim.g.UltiSnipsExpandTrigger = "<tab>"
      vim.g.UltiSnipsJumpForwardTrigger = "<c-n>"
      vim.g.UltiSnipsJumpBackwardTrigger = "<c-p>"
      vim.g.UltiSnipsEditSplit = 'vertical'
      vim.g.UltiSnipsRemoveSelectModeMappings = 0
    ]]
  },
  {
    'nvim-telescope/telescope.nvim'
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  { 'neovim/nvim-lspconfig' },
  {'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = { },
  },
  {
      'jedrzejboczar/exrc.nvim',
      dependencies = {'neovim/nvim-lspconfig'},
      config = true,
      opts = { 
        files = {
          ".nvimrc.lua",
          ".nvimrc",
          ".exrc.lua",
          ".exrc",
        },
      } ,
  },
  { 
    'nvim-treesitter/nvim-treesitter', 
    run = ':TSUpdate',
    opts = {
      auto_install = true,
      ignore_install = {},

      highlight = {
        enable = true,
      },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = { },
  },
  { 'tpope/vim-fugitive' },
}

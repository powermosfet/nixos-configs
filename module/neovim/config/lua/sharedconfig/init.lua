require('sharedconfig.plugins')

local g = vim.g
local api = vim.api

vim.o.hidden = true
vim.o.relativenumber = true

local keymapOptions = { noremap=true, silent=false }

function kmap(prefix, definitions) 
  if type(definitions) == "table" then
    for k, a in pairs(definitions) do
      kmap(prefix .. k, a)
    end
  else
    api.nvim_set_keymap("n", prefix, definitions, keymapOptions)
  end
end

g.mapleader = " "
g.maplocalleader = " "

local keymaps = require("sharedconfig.keymaps")
kmap("", keymaps)
api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", keymapOptions)

-- OPTIONS

local set_all = function(value, list)
  for _, item in pairs(list) do
    vim.o[item] = value
  end
end

set_all(true, { "termguicolors", "hidden", "splitright", "number", "relativenumber", "ignorecase", "smartcase" })
set_all(false, { "fixendofline" })
set_all("nicr", { "mouse" })

vim.cmd('colorscheme everforest')


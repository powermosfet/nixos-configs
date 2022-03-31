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

local keymaps = {
  ["<BS>"]        = [[:BufferPrevious<CR>]],
  ["<TAB>"]       = [[:BufferNext<CR>]],
  ["[g"]          = [[:lua vim.lsp.diagnostic.goto_prev()<CR>]],
  ["]g"]          = [[:lua vim.lsp.diagnostic.goto_next()<CR>]],
  ["<leader>"]    = {
    ["v"]         = [[:tabe <c-r>=resolve($MYVIMRC)<cr><cr>]],
    ["n"]         = [[:noh<cr>]],
    ["c"]         = [[:close<cr>]],
    [","]         = [[:tabp<cr>]],
    ["."]         = [[:tabn<cr>]],
    -- Tabs
    ["t"]         = {
      ["c"]       = [[:tabclose<cr>]],
      ["o"]       = [[:tabonly<cr>]],
      ["e"]       = [[:tabe ]],
      ["<BS>"]    = [[:BufferMovePrevious<cr>]],
      ["<TAB>"]   = [[:BufferMoveNext<cr>]],
    },
    -- Search
    ["s"]         = {
      ["w"]       = [[:Telescope grep_string<cr>]],
      ["l"]       = [[:Telescope live_grep<cr>]],
    },
    -- Buffer
    ["b"]         = {
      ["l"]       = [[:Telescope buffers<cr>]],
      ["o"]       = [[:b#<cr>]],
      ["d"]       = [[:bd<cr>]],
    },
    -- Files
    ["f"]         = {
      ["f"]       = [[:Telescope find_files<cr>]],
      ["b"]       = [[:Telescope file_browser<cr>]],
      ["t"]       = [[:NERDTreeFocus<cr>]],
      ["T"]       = [[:NERDTreeFind<cr>]],
    },
    -- Git
    ["g"]         = {
      ["<space>"] = [[:G ]],
      ["b"]       = [[:Telescope git_branches<cr>]],
      ["c"]       = [[:Telescope git_bcommits<cr>]],
      ["s"]       = [[:G<cr>]],
      ["f"]       = [[:Git fetch --prune<cr>]],
      ["p"]       = [[:Git pull --ff-only<cr>]],
      ["o"]       = [[:Git checkout ]],
      ["n"]       = [[/\(<<<<<<<\|=======\||||||||\|>>>>>>>\)<cr>]]
    },
    ["l"]         = {
      ["z"]       = [[:LspRestart<CR>]],
      ["f"]       = [[:lua vim.lsp.buf.formatting()<CR>]],
      ["D"]       = [[:lua vim.lsp.buf.declaration()<CR>]],
      ["d"]       = [[:lua vim.lsp.buf.definition()<CR>]],
      ["h"]       = [[:lua vim.lsp.buf.hover()<CR>]],
      ["i"]       = [[:lua vim.lsp.buf.implementation()<CR>]],
      ["R"]       = [[:lua vim.lsp.buf.rename()<CR>]],
      ["a"]       = [[:Telescope lsp_code_actions<CR>]],
      ["r"]       = [[:Telescope lsp_references<CR>]],
      ["gb"]      = [[:Telescope lsp_document_diagnostics<CR>]],
      ["gw"]      = [[:Telescope lsp_workspace_diagnostics<CR>]],
      ["/"]       = [[:Telescope lsp_document_symbols<CR>]],
      ["g/"]      = [[:Telescope lsp_workspace_symbols<CR>]]
    }
  }
}

kmap("", keymaps)

-- OPTIONS

local set_all = function(value, list)
  for _, item in pairs(list) do
    vim.o[item] = value
  end
end

set_all(true, { "termguicolors", "hidden", "splitright", "number", "relativenumber", "ignorecase", "smartcase" })
set_all(false, { "fixendofline" })
set_all("nicr", { "mouse" })

vim.g.UltiSnipsSnippetDirectories = { "~/.dotfiles/vim/UltiSnips" }
vim.g.UltiSnipsEditSplit = 'vertical'
vim.g.UltiSnipsExpandTrigger="<tab>"
vim.g.UltiSnipsJumpForwardTrigger="<c-n>"
vim.g.UltiSnipsJumpBackwardTrigger="<c-p>"

-- LANGUAGE SERVERS

lspconfig = require('lspconfig')

function setup_lsp(servers)
  for _, server in ipairs(servers) do
    lspconfig[server].setup {
      flags = {
        debounce_text_changes = 500,
      }
    }
  end
end

function local_config()
  pcall(dofile, vim.fn.getcwd() .. "/.nvim.lua")
end

local_config()
vim.api.nvim_command [[augroup LocalConfig]]
vim.api.nvim_command [[autocmd! * *]]
vim.api.nvim_command [[autocmd DirChanged * lua local_config()]]
vim.api.nvim_command [[augroup END]]


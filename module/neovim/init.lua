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
    if type(server) == "string" then
      server_name = server
      server_config = {
        flags = {
          debounce_text_changes = 500,
        }
      }
    else
      server_name = server.name
      server_config = server.config
    end
    
    lspconfig[server_name].setup(server_config)
  end
end

-- nvim-cmp
local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local cmp = require'cmp'
cmp.setup {
      snippet = {
         expand = function(args)
           vim.fn["UltiSnips#Anon"](args.body)
         end,
      },
      mapping = {
         ["<C-d>"] = cmp.mapping.scroll_docs(-4),
         ["<C-f>"] = cmp.mapping.scroll_docs(4),
         ["<C-e>"] = cmp.mapping.close(),
         ["<C-Space>"] = cmp.mapping.complete(),
         ["<CR>"] = cmp.mapping.confirm({ select = true }),
         ["<c-y>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
         },
         ["<Tab>"] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    cmp.complete()
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                    vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
                else
                    fallback()
                end
            end,
            s = function(fallback)
                if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                    vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
                else
                    fallback()
                end
            end
        }),
        ["<S-Tab>"] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    cmp.complete()
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                    return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
                else
                    fallback()
                end
            end,
            s = function(fallback)
                if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                    return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
                else
                    fallback()
                end
            end
         }),
         ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
         ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
      },
      sources = {
         { name = "nvim_lsp"},
         { name = "path" },
         { name = "ultisnips" },
         { name = "buffer" , keyword_length = 5},
      },
      experimental = {
         ghost_text = true
      }
}

function local_config()
  pcall(dofile, vim.fn.getcwd() .. "/.nvim.lua")
end

local_config()


return {
  ["<PageUp>"]       = [[:BufferPrevious<cr>]],
  ["<PageDown>"]     = [[:BufferNext<cr>]],
  ["[g"]             = [[:lua vim.diagnostic.goto_prev()<CR>]],
  ["]g"]             = [[:lua vim.diagnostic.goto_next()<CR>]],
  -- Diagnostics
  ["d"]              = {
    ["n"]            = [[:lua vim.diagnostic.goto_next()<cr>]],
    ["p"]            = [[:lua vim.diagnostic.goto_prev()<cr>]],
    ["l"]            = [[:Telescope diagnostics bufnr=0<cr>]],
    ["L"]            = [[:Telescope diagnostics<cr>]],
  },
  -- Bookmarks
  ["m"]              = {
    ["t"]            = [[:Telescope vim_bookmarks current_file<cr>]],
    ["T"]            = [[:Telescope vim_bookmarks all<cr>]],
  },
  -- Jumping around
  [")"]              = {
    ["f"]            = [[:TSTextobjectGotoNextStart @function.outer<cr>]],
    ["p"]            = [[:TSTextobjectGotoNextStart @parameter.outer<cr>]],
  },
  ["("]              = {
    ["f"]            = [[:TSTextobjectGotoPreviousStart @function.outer<cr>]],
    ["p"]            = [[:TSTextobjectGotoPreviousStart @parameter.outer<cr>]],
  },
  -- Leader
  ["<leader>"]       = {
    ["v"]            = [[:tabe <c-r>=resolve($MYVIMRC)<cr><cr>]],
    ["n"]            = [[:noh<cr>]],
    ["c"]            = [[:close<cr>]],
    [","]            = [[:tabp<cr>]],
    ["."]            = [[:tabn<cr>]],
    -- Search
    ["s"]            = {
      ["w"]          = [[:Telescope grep_string<cr>]],
      ["l"]          = [[:Telescope live_grep<cr>]],
    },
    -- Buffer
    ["b"]            = {
      ["l"]          = [[:Telescope buffers<cr>]],
      ["o"]          = [[:b#<cr>]],
      ["d"]          = [[:BufferDelete<cr>]],
      ["c"]          = [[:BufferClose<cr>]],
      ["O"]          = [[:BufferCloseAllButCurrentOrPinned<cr>]],
      ["p"]          = [[:BufferPin<cr>]],
      ["j"]          = [[:BufferPick<cr>]],
      ["<PageUp>"]   = [[:BufferMovePrevious<cr>]],
      ["<PageDown>"] = [[:BufferMoveNext<cr>]],
    },
    -- Files
    ["f"]            = {
      ["f"]          = [[:Telescope find_files<cr>]],
      ["b"]          = [[:Telescope file_browser<cr>]],
      ["t"]          = [[:Neotree<cr>]],
      ["T"]          = [[:Neotree reveal<cr>]],
    },
    -- Git
    ["g"]            = {
      ["b"]          = [[:Gitsigns blame<cr>]],
      ["n"]          = [[/\([<|=>]\)\1\{6\}<cr>]],
      ["g"]          = [[:Git<cr>]]
    },
    ["l"]            = {
      ["z"]          = [[:LspRestart<CR>]],
      ["f"]          = [[:lua vim.lsp.buf.formatting()<CR>]],
      ["D"]          = [[:lua vim.lsp.buf.declaration()<CR>]],
      ["d"]          = [[:lua vim.lsp.buf.definition()<CR>]],
      ["h"]          = [[:lua vim.lsp.buf.hover()<CR>]],
      ["i"]          = [[:lua vim.lsp.buf.implementation()<CR>]],
      ["R"]          = [[:lua vim.lsp.buf.rename()<CR>]],
      ["a"]          = [[:lua vim.lsp.buf.code_action()<CR>]],
      ["r"]          = [[:Telescope lsp_references<CR>]],
      ["gb"]         = [[:Telescope lsp_document_diagnostics<CR>]],
      ["gw"]         = [[:Telescope lsp_workspace_diagnostics<CR>]],
      ["/"]          = [[:Telescope lsp_document_symbols<CR>]],
      ["g/"]         = [[:Telescope lsp_workspace_symbols<CR>]]
    }
  }
}


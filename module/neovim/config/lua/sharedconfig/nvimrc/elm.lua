require'lspconfig'.elmls.setup{
    cmd = { "elm-language-server" },
}

vim.api.nvim_create_augroup("elmAutoCmds", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    group = "elmAutoCmds",
    pattern = { "*.elm" },
    command = "silent! !elm-format --yes %",
})

vim.api.nvim_create_autocmd("FileType" , { 
    group = "elmAutoCmds",
    pattern = { "elm" },
    command = "silent setlocal colorcolumn=80"
})

vim.api.nvim_create_autocmd("CursorHold" , { 
    group = "elmAutoCmds",
    pattern = { "*.elm" },
    callback = function() pcall(vim.lsp.buf.hover) end,
})


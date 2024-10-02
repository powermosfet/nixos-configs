local capabilities = require('cmp_nvim_lsp').default_capabilities()

require'lspconfig'.elmls.setup{
    cmd = { "elm-language-server" },
    capabilities = capabilities,
    init_options = {
        onlyUpdateDiagnosticsOnSave = true
    }
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

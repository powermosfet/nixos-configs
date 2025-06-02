vim.api.nvim_create_augroup("nixAutoCmds", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    group = "nixAutoCmds",
    pattern = { "*.nix" },
    command = "silent! !nixfmt %",
})

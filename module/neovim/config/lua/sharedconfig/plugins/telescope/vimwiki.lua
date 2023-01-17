require('telescope').load_extension('vimwiki')

vim.api.nvim_create_augroup("telescopeVimwikiAutoCommands", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "telescopeVimwikiAutoCommands",
    pattern = { "vimwiki" },
    callback = function()
        vim.keymap.set('n', '<leader>ff', ':lua require("telescope").extensions.vimwiki.vimwiki()<cr>', { buffer = true })
        vim.keymap.set('n', '<leader>sl', ':lua require("telescope").extensions.vw.live_grep()<cr>',    { buffer = true })
        vim.keymap.set('n', '<leader><leader>', ':VimwikiToggleListItem<cr>',    { buffer = true })
    end,
})

vim.g.vimwiki_dir_link="index"

vim.api.nvim_create_augroup("vimwikiAutoCommands", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "vimwikiAutoCommands",
    pattern = { "vimwiki" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.keymap.set("i", "<Tab>", "<C-O>gll", { noremap = true, buffer = true })
        vim.keymap.set("i", "<S-Tab>", "<C-O>glh", { noremap = true, buffer = true })
    end
})

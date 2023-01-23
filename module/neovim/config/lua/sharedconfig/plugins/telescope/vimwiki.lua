require('telescope').load_extension('vimwiki')

vim.keymap.set('n', '<leader>wf', ':Telescope vimwiki<cr>')
vim.keymap.set('n', '<leader>w/', ':Telescope vimwiki live_grep<cr>')
vim.keymap.set('n', '<leader>wl', ':Telescope vimwiki links<cr>')

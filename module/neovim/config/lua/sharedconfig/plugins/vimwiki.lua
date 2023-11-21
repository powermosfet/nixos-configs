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
        vim.g.vimwiki_list = {
            {
                path = "~/vimwiki",
                syntax = "markdown",
                ext = ".md",
                links_space_char = "_",
                auto_tags = 1,
            },
          }

          -- Disable header levels keybindings so oil.nvim will work
          vim.g.vimwiki_key_mappings = {
              headers = 0,
          }

          -- Syntax highlighting for code blocks
          vim.g.vimwiki_syntax_plugins = {
              codeblock = {
                  ["```lua"] = { parser = "lua" },
                  ["```python"] = { parser = "python" },
                  ["```javascript"] = { parser = "javascript" },
                  ["```bash"] = { parser = "bash" },
                  ["```shell"] = { parser = "bash" },
                  ["```mermaid"] = { parser = "mermaid" },
                  ["```html"] = { parser = "html" },
                  ["```css"] = { parser = "css" },
                  ["```c"] = { parser = "c" },
              },
          }
      end
  })

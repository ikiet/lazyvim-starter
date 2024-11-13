-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.showtabline = 0
vim.g.autoformat = false
vim.g.lazyvim_php_lsp = "intelephense"
vim.opt.spell = false
vim.opt.spelllang = { "en", "cjk" }
vim.opt.spelloptions:append({ 'noplainbuffer', "camel" })
vim.opt.scrolloff = 10 -- Lines of context

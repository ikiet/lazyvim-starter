-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- keymap
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

-- Better window navigation
keymap("n", "<M-h>", "<C-w>h", opts)
keymap("n", "<M-j>", "<C-w>j", opts)
keymap("n", "<M-k>", "<C-w>k", opts)
keymap("n", "<M-l>", "<C-w>l", opts)

keymap("v", "p", '"_dP', opts)

keymap("n", "<CR>", "ggvG=", opts)

keymap("v", "<CR>", "=", opts)

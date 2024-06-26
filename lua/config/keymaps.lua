-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- keymap
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

keymap("n", "<C-h>", function()
  require("kitty-navigator").navigateLeft()
end, opts)
keymap("n", "<C-j>", function()
  require("kitty-navigator").navigateDown()
end, opts)
keymap("n", "<C-k>", function()
  require("kitty-navigator").navigateUp()
end, opts)
keymap("n", "<C-l>", function()
  require("kitty-navigator").navigateRight()
end, opts)

keymap("v", "p", '"_dP', opts)

keymap("n", "<CR>", "ggvG=", opts)

keymap("v", "<CR>", "=", opts)

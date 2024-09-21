-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- keymap
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

keymap("i", "<C-f>", "<Right>", opts)
keymap("i", "<C-b>", "<Left>", opts)
keymap("i", "<C-e>", "<End>", opts)
keymap("i", "<C-a>", "<Home>", opts)

-- keymap({ "n", "i" }, "<C-h>", function()
--   require("kitty-navigator").navigateLeft()
-- end, opts)
-- keymap({ "n", "i" }, "<C-j>", function()
--   require("kitty-navigator").navigateDown()
-- end, opts)
-- keymap({ "n", "i" }, "<C-k>", function()
--   require("kitty-navigator").navigateUp()
-- end, opts)
-- keymap({ "n", "i" }, "<C-l>", function()
--   require("kitty-navigator").navigateRight()
-- end, opts)

keymap("v", "p", '"_dP', opts)

keymap("n", "<C-w>m", "<C-w>|<C-w>_", opts)

keymap("n", "cp", ":cd %:p:h<CR>", opts)

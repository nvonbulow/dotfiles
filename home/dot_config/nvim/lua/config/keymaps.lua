-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "tt", "<cmd>terminal<cr>i", { desc = "Open terminal in current window" })
vim.keymap.set("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New empty buffer" })

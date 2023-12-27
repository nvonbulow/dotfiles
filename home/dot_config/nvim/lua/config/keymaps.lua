
local set = vim.keymap.set
-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help set()`
set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Quit
set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })

-- [[ Window/Tab Navigation Keymaps ]]

-- Move between windows using <C-hjkl> keys
-- Note: this is now handled by vim-tmux-navigator
-- set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', remap = true })
-- set('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', remap = true })
-- set('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', remap = true })
-- set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', remap = true })

-- Window Management
set('n', '<leader>ww', '<C-w>p', { desc = 'Other window', remap = true })
set('n', '<leader>wd', '<C-w>c', { desc = 'Delete window', remap = true })
set('n', '<leader>w-', '<C-w>s', { desc = 'Split window below', remap = true })
set('n', '<leader>w|', '<C-w>v', { desc = 'Split window right', remap = true })
set('n', '<leader>-', '<C-w>s', { desc = 'Split window below', remap = true })
set('n', '<leader>|', '<C-w>v', { desc = 'Split window right', remap = true })

-- Tab Management
set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Diagnostic keymaps
set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })


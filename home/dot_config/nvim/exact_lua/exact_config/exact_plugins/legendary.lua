return {
  'mrjones2014/legendary.nvim',
  lazy = false,
  keys = {
    { '<leader>sk', '<cmd>Legendary keymaps<cr>', desc = '[S]earch [K]eymaps' },
    { '<leader>s;', '<cmd>Legendary commands<cr>', desc = '[S]earch Commands' },
  },
  opts = {
    extensions = {
      lazy_nvim = { auto_register = true },
    },
  },
}

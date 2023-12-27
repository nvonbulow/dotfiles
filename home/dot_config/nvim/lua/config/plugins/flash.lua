---@type LazySpec
return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    keys = function()
      local flash = require('flash')
      return {
        { 's', mode = { 'n', 'x', 'o' }, flash.jump, desc = 'Flash' },
        { 'S', mode = { 'n', 'x', 'o' }, flash.treesitter, desc = 'Flash Treesitter' },
        { 'r', mode = 'o', flash.remote, desc = 'Remote Flash' },
        { 'R', mode = { 'x', 'o' }, flash.treesitter_search, desc = 'Treesitter Search' },
        { '<c-s>', mode = { 'c' }, flash.toggle, desc = 'Toggle Flash Search' },
      }
    end,
  },
}

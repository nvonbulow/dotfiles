---@type LazySpec
return {
  {
    'voldikss/vim-floaterm',
    cond = false,
    cmd = {
      'FloatermNew',
      'FloatermToggle',
      'FloatermNext',
      'FloatermPrev',
      'FloatermKill',
    },
    keys = {
      { '<leader>gl', 'FloatermNew lazygit' },
    },
    opts = {},
  }
}

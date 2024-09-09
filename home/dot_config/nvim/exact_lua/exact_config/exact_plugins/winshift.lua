---@type LazySpec
return {
  {
    'sindrets/winshift.nvim',
    event = 'VeryLazy',
    config = true,
    keys = {
      {
        '<leader>wsh',
        '<cmd>WinShift left<cr>',
        desc = 'Shift window left',
      },
      {
        '<leader>wsj',
        '<cmd>WinShift down<cr>',
        desc = 'Shift window down',
      },
      {
        '<leader>wsk',
        '<cmd>WinShift up<cr>',
        desc = 'Shift window up',
      },
      {
        '<leader>wsl',
        '<cmd>WinShift right<cr>',
        desc = 'Shift window right',
      },
      {
        '<leader>wsH',
        '<cmd>WinShift far_left<cr>',
        desc = 'Shift window far left',
      },
      {
        '<leader>wsJ',
        '<cmd>WinShift far_down<cr>',
        desc = 'Shift window far down',
      },
      {
        '<leader>wsK',
        '<cmd>WinShift far_up<cr>',
        desc = 'Shift window far up',
      },
      {
        '<leader>wsL',
        '<cmd>WinShift far_right<cr>',
        desc = 'Shift window far right',
      },
    },
  },
  -- add description for whichkey
  {
    'folke/which-key.nvim',
    optional = true,
    opts = {
      defaults = {
        { '<leader>ws', group = 'shift' },
      },
    },
  },
}

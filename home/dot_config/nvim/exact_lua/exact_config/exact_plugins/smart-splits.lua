return {
  {
    'mrjones2014/smart-splits.nvim',
    keys = {
      { '<a-h>', function() require('smart-splits').resize_left() end, desc = 'Resize pane left' },
      { '<a-j>', function() require('smart-splits').resize_down() end, desc = 'Resize pane down' },
      { '<a-k>', function() require('smart-splits').resize_up() end, desc = 'Resize pane up' },
      { '<a-l>', function() require('smart-splits').resize_right() end, desc = 'Resize pane right' },
    },
    opts = {},
  },
}

return {
  {
    'mrjones2014/smart-splits.nvim',
    keys = {
      { '<c-h>', function() require('smart-splits').move_cursor_left() end, desc = 'Go to left window' },
      { '<c-j>', function() require('smart-splits').move_cursor_down() end, desc = 'Go to left window' },
      { '<c-k>', function() require('smart-splits').move_cursor_up() end, desc = 'Go to left window' },
      { '<c-l>', function() require('smart-splits').move_cursor_right() end, desc = 'Go to left window' },
      { '<a-h>', function() require('smart-splits').resize_left(3) end, desc = 'Resize pane left' },
      { '<a-j>', function() require('smart-splits').resize_down(3) end, desc = 'Resize pane down' },
      { '<a-k>', function() require('smart-splits').resize_up(3) end, desc = 'Resize pane up' },
      { '<a-l>', function() require('smart-splits').resize_right(3) end, desc = 'Resize pane right' },
    },
    opts = {},
  },
}

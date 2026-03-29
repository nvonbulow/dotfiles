return {
  {
    'nickjvandyke/opencode.nvim',
    version = '*',
    dependencies = {
      {
        'folke/snacks.nvim',
        optional = true,
        opts = {
          input = {},
          picker = {
            actions = {
              opencode_send = function(...) return require('opencode').snacks_picker_send(...) end,
            },
            win = {
              input = {
                keys = {
                  ['<a-a>'] = { 'opencode_send', mode = { 'n', 'i' } },
                },
              },
            },
          },
        },
      },
    },
    keys = {
      { '<C-a>', function() require('opencode').ask('@this: ', { submit = true }) end, mode = { 'n', 'x' }, desc = 'Ask opencode' },
      { '<C-x>', function() require('opencode').select() end, mode = { 'n', 'x' }, desc = 'Execute opencode action' },
      { '<C-\\>', function() require('opencode').toggle() end, mode = { 'n', 't' }, desc = 'Toggle opencode' },
      { 'go', function() return require('opencode').operator '@this ' end, mode = { 'n', 'x' }, expr = true, desc = 'Add range to opencode' },
      { 'goo', function() return require('opencode').operator '@this ' .. '_' end, expr = true, desc = 'Add line to opencode' },
      { '<S-C-u>', function() require('opencode').command 'session.half.page.up' end, desc = 'Scroll opencode up' },
      { '<S-C-d>', function() require('opencode').command 'session.half.page.down' end, desc = 'Scroll opencode down' },
      { '+', '<C-a>', desc = 'Increment under cursor' },
      { '-', '<C-x>', desc = 'Decrement under cursor' },
    },
    config = function()
      vim.g.opencode_opts = {}
      vim.o.autoread = true
    end,
  },
}

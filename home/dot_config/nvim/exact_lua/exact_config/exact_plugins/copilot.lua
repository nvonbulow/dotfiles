---@type LazyConfig
return {
  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    cmd = { 'Copilot' },
    keys = {
      {
        '<M-]>',
        function()
          require('copilot.suggestion').next()
        end,
        mode = 'i',
        desc = 'Next Copilot Suggestion',
      },
      {
        '<M-[>',
        function()
          require('copilot.suggestion').prev()
        end,
        mode = 'i',
        desc = 'Previous Copilot Suggestion',
      },
      {
        '<M-l>',
        function()
          require('copilot.suggestion').accept()
        end,
        mode = 'i',
        desc = 'Accept Copilot Suggestion',
      },
      -- {
      --   '<Tab>',
      --   function()
      --     require('copilot.suggestion').accept()
      --   end,
      --   mode = 'i',
      --   desc = 'Accept Copilot Suggestion',
      -- },
      {
        '<M-k>',
        function()
          require('copilot.suggestion').accept_word()
        end,
        mode = 'i',
        desc = 'Accept Copilot Suggestion (Word)',
      },
      {
        '<M-;>',
        function()
          require('copilot.suggestion').cancel()
        end,
        mode = 'i',
        desc = 'Cancel Copilot Suggestion',
      },
    },
    opts = {
      suggestion = {
        auto_trigger = true,
      },
    },
  },
  {
    'zbirenbaum/copilot-cmp',
    dependencies = {
      'zbirenbaum/copilot.lua',
    },
    opts = {},
  },
}

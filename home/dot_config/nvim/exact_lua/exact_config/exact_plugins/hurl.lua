---@type LazySpec
return {
  {
    'jellydn/hurl.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    ft = 'hurl',
    opts = {
      --Show Debugging info
      debug = false,
      --Show notifications on run
      show_notifications = true,
      --Show response in popup or split
      mode = 'split',
      --Formatters
      formatters = {
        json = { 'jq' },
        html = { 'prettier', '--parser', 'html' },
      },
    },
    keys = {
      -- HurlRunner
      { '<leader>hA', '<cmd>HurlRunner<cr>', desc = 'Run All requests', ft = 'hurl' },
      -- HurlRunnerAt
      { '<leader>ha', '<cmd>HurlRunnerAt<cr>', desc = 'Run Api request', ft = 'hurl' },
      -- HurlRunnerToEntry
      { '<leader>hE', '<cmd>HurlRunnerToEntry<cr>', desc = 'Run to entry', ft = 'hurl' },
      -- HurlVerbose
      { '<leader>hv', '<cmd>HurlVerbose<cr>', desc = 'Run Api in verbose mode', ft = 'hurl' },
      -- run in visual mode
      { '<leader>hh', '<cmd>HurlRunner<cr>', desc = 'Run in visual mode', ft = 'hurl', mode = 'v' },
    },
  },
}

---@type LazySpec
return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    init = function()
      vim.opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }
    end,
    ---@type PersistenceOptions
    opts = {
      options = vim.opt.sessionoptions:get(),
      pre_save = function()
        -- Close any neo-tree pane since this causes a bug upon session restore for some reason
        if package.loaded['neo-tree'] then
          require('neo-tree.command').execute({ action = 'close' })
        end
      end,
    },
    keys = {
      {
        '<leader>qs',
        function()
          require('persistence').load()
        end,
        desc = 'Restore Session',
      },
      {
        '<leader>ql',
        function()
          require('persistence').load({ last = true })
        end,
        desc = 'Restore Last Session',
      },
      {
        '<leader>qd',
        function()
          require('persistence').stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },
}

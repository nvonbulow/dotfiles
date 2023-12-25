---@type LazySpec
return {
  {
    'rcarriga/nvim-notify',
    ---@type notify.Config
    opts = {
      minimum_width = 50,
      stages = 'fade',
      timeout = 2000,
      fps = 60,
    },
    config = function(_, opts)
      local notify = require('notify')
      vim.notify = notify

      notify.setup(opts)
    end,
  }
}

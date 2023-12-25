---@type LazySpec
return {
  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    init = function ()
      -- customize the timeout before the which-key popup appears
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    opts = {
      defaults = {
        -- document existing key chains
        ['<leader>b'] = { name = '[B]uffer', _ = 'which_key_ignore' },
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
        ['<leader>q'] = { name = '[Q]uit/session', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
        ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
      },
      defaults_visual = {
        -- required for visual <leader>hs (hunk stage) to work
        ['<leader>'] = { name = 'VISUAL <leader>' },
      },
    },
    config = function(_, opts)
      require('which-key').setup(opts)

      require('which-key').register(opts.defaults)
      require('which-key').register(opts.defaults_visual, { mode = 'v' })
    end,
  },
}

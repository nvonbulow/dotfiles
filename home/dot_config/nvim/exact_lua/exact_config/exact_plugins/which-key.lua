---@type LazySpec
return {
  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    init = function()
      -- customize the timeout before the which-key popup appears
      -- vim.o.timeout = true
      -- vim.o.timeoutlen = 500
    end,
    opts = {
      defaults = {
        -- document existing key chains
        { '<leader>b', group = '[B]uffer' },
        { '<leader>b_', hidden = true },
        { '<leader>c', group = '[C]ode' },
        { '<leader>c_', hidden = true },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>d_', hidden = true },
        { '<leader>g', group = '[G]it' },
        { '<leader>g_', hidden = true },
        { '<leader>gh', group = 'Git [H]unk' },
        { '<leader>gh_', hidden = true },
        { '<leader>q', group = '[Q]uit/session' },
        { '<leader>q_', hidden = true },
        { '<leader>r', group = '[R]ename' },
        { '<leader>r_', hidden = true },
        { '<leader>s', group = '[S]earch' },
        { '<leader>s_', hidden = true },
        { '<leader>sn', group = '[S]earch [N]oice' },
        { '<leader>sn_', hidden = true },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>t_', hidden = true },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>w_', hidden = true },
        { '<leader>ws', group = 'shift' },
        { '[', group = 'goto previous' },
        { ']', group = 'goto next' },
        { 'g', group = 'goto' },
        { 'gs', group = 'surround' },
        { 'y', group = 'yank' },
      },
      defaults_visual = {
        -- required for visual <leader>hs (hunk stage) to work
        { '<leader>ws', group = 'shift' },
      },
      plugins = {
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
    },
    config = function(_, opts)
      require('which-key').setup(opts)

      require('which-key').add(opts.defaults)
      require('which-key').add(opts.defaults_visual, { mode = 'v' })
    end,
  },
}

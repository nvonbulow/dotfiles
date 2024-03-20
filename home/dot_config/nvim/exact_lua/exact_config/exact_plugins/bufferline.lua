---@type LazySpec
return {
  {
    'akinsho/bufferline.nvim',
    -- TODO: BufReadPost and BufNewFile don't account for restoring a session from the dashboard
    -- event = { 'BufReadPost', 'BufNewFile' },
    event = 'VeryLazy',
    cond = not vim.g.started_by_firenvim,
    keys = {
      { '<leader>bp', '<cmd>BufferLineTogglePin<cr>', desc = 'Toggle pin' },
      { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete non-pinned buffers' },
      { '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete other buffers' },
      { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete buffers to the right' },
      { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete buffers to the left' },
      { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
      { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
      { '<A-S-h>', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer left' },
      { '<A-S-l>', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer right' },
      { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
      { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
      { '<C-1>', '<cmd>BufferLineGoToBuffer 1<cr>', desc = 'Go to Buffer 1' },
      { '<C-2>', '<cmd>BufferLineGoToBuffer 2<cr>', desc = 'Go to Buffer 2' },
      { '<C-3>', '<cmd>BufferLineGoToBuffer 3<cr>', desc = 'Go to Buffer 3' },
      { '<C-4>', '<cmd>BufferLineGoToBuffer 4<cr>', desc = 'Go to Buffer 4' },
      { '<C-5>', '<cmd>BufferLineGoToBuffer 5<cr>', desc = 'Go to Buffer 5' },
      { '<C-6>', '<cmd>BufferLineGoToBuffer 6<cr>', desc = 'Go to Buffer 6' },
      { '<C-7>', '<cmd>BufferLineGoToBuffer 7<cr>', desc = 'Go to Buffer 7' },
      { '<C-8>', '<cmd>BufferLineGoToBuffer 8<cr>', desc = 'Go to Buffer 8' },
      { '<C-9>', '<cmd>BufferLineGoToBuffer 9<cr>', desc = 'Go to Buffer 9' },
      { '<C-0>', '<cmd>BufferLineGoToBuffer 10<cr>', desc = 'Go to Buffer 10' },
    },
    opts = {
      ---@type bufferline.Options
      options = {
        close_command = function(n)
          require('mini.bufremove').delete(n, false)
        end,
        right_mouse_command = false,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'Explorer',
            highlight = 'directory',
            text_align = 'center',
          },
        },
        separator_style = { "", "" },
        indicator = {
          style = 'underline',
        },
        diagnostics = 'nvim_lsp',
      },
    },
    config = function(_, opts)
      require('bufferline').setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd('BufAdd', {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
    dependencies = {
      'echasnovski/mini.bufremove',
      'nvim-tree/nvim-web-devicons',
    },
  },
}

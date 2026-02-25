return {
  {
    'echasnovski/mini.bufremove',
    keys = {
      {
        '<leader>bd',
        function()
          local bd = require('mini.bufremove').delete
          -- Confirm pending changes
          if vim.bo.modified then
            local choice = vim.fn.confirm(('Save changes to %q'):format(vim.fn.bufname()), '&Yes\n&No\n&Cancel')
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = 'Delete buffer',
      },
      {
        '<leader>bD',
        function() require('mini.bufremove').delete(0, true) end,
        desc = 'Delete Buffer (Forced)',
      },
    },
  },
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    keys = {
      { '<leader>bp', '<cmd>BufferLineTogglePin<cr>', desc = '[B]uffer [p]in toggle' },
      { '<leader>bP', '<cmd>BufferLineGroupClose ungrouped<cr>', desc = '[B]uffer [P]in/close ungrouped' },
      { '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', desc = '[B]uffer [o]thers close' },
      { '<leader>br', '<cmd>BufferLineCloseRight<cr>', desc = '[B]uffer close [r]ight' },
      { '<leader>bl', '<cmd>BufferLineCloseLeft<cr>', desc = '[B]uffer close [l]eft' },
      { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
      { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
      { '<A-S-h>', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer left' },
      { '<A-S-l>', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer right' },
      { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
      { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
      { '<C-1>', '<cmd>BufferLineGoToBuffer 1<cr>', desc = 'Go to buffer 1' },
      { '<C-2>', '<cmd>BufferLineGoToBuffer 2<cr>', desc = 'Go to buffer 2' },
      { '<C-3>', '<cmd>BufferLineGoToBuffer 3<cr>', desc = 'Go to buffer 3' },
      { '<C-4>', '<cmd>BufferLineGoToBuffer 4<cr>', desc = 'Go to buffer 4' },
      { '<C-5>', '<cmd>BufferLineGoToBuffer 5<cr>', desc = 'Go to buffer 5' },
      { '<C-6>', '<cmd>BufferLineGoToBuffer 6<cr>', desc = 'Go to buffer 6' },
      { '<C-7>', '<cmd>BufferLineGoToBuffer 7<cr>', desc = 'Go to buffer 7' },
      { '<C-8>', '<cmd>BufferLineGoToBuffer 8<cr>', desc = 'Go to buffer 8' },
      { '<C-9>', '<cmd>BufferLineGoToBuffer 9<cr>', desc = 'Go to buffer 9' },
      { '<C-0>', '<cmd>BufferLineGoToBuffer 10<cr>', desc = 'Go to buffer 10' },
    },
    opts = {
      options = {
        close_command = function(n) require('mini.bufremove').delete(n, false) end,
        right_mouse_command = false,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'Explorer',
            highlight = 'directory',
            text_align = 'center',
          },
        },
        separator_style = { '', '' },
        indicator = {
          style = 'underline',
        },
        diagnostics = 'nvim_lsp',
      },
    },
    config = function(_, opts)
      require('bufferline').setup(opts)
      vim.api.nvim_create_autocmd('BufAdd', {
        callback = function()
          vim.schedule(function() pcall(vim_bufferline) end)
        end,
      })
    end,
    dependencies = {
      'echasnovski/mini.bufremove',
      'nvim-tree/nvim-web-devicons',
    },
  },
  {
    'Bekaboo/dropbar.nvim',
    event = 'VeryLazy',
    keys = {
      { '<leader>;', function() require('dropbar.api').pick() end, desc = 'Pick symbols in winbar' },
      { '[;', function() require('dropbar.api').goto_context_start() end, desc = 'Go to start of current context' },
      { '];', function() require('dropbar.api').select_next_context() end, desc = 'Select next context' },
    },
  },
}

---@type LazySpec
return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
      '3rd/image.nvim',
    },
    keys = {
      { '<leader>e', '<cmd>Neotree toggle<cr>', desc = 'Toggle Neotree' },
    },
    init = function()
      -- Disable builtin netrw plugin in favor of Neotree
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == 'directory' then
          require('neo-tree')
        end
      end
    end,
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    opts = {
      sources = {
        'filesystem',
        'buffers',
        'git_status',
        'document_symbols',
      },
      open_files_do_not_replace_types = {
        'terminal',
        'trouble',
        'Trouble',
        'qf',
        'Outline',
      },
      filesystem = {
        -- disable 2-way binding between cwd and neo-tree's root
        bind_to_cwd = false,
        -- find and focus the file in the active buffer
        follow_current_file = { enabled = true },
        -- More performant file change detection
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          -- disable space key, since that is our leader key
          ['<space>'] = 'none',
        },
      },
      default_component_configs = {
        indent = {
          -- if nil and file nesting is enabled, will enable expanders
          with_expanders = true,
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
      },
    },
    config = function (self, opts)
      require('neo-tree').setup(opts)

      vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function ()
          self:deactivate()
        end
      })
    end
  },
}

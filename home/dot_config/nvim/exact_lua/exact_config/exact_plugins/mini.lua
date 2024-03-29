---@type LazySpec
return {
  {
    'echasnovski/mini.animate',
    event = 'VeryLazy',
    opts = function()
      -- disable animation when scrolling with the mouse
      local mouse_scrolled = false
      vim.keymap.set({ '', 'i' }, '<ScrollWheelUp>', function()
        mouse_scrolled = true
        return '<ScrollWheelUp>'
      end, { expr = true })
      vim.keymap.set({ '', 'i' }, '<ScrollWheelDown>', function()
        mouse_scrolled = true
        return '<ScrollWheelDown>'
      end, { expr = true })

      local animate = require('mini.animate')
      return {
        resize = {
          timing = animate.gen_timing.linear({ duration = 100, unit = 'total' }),
        },
        scroll = {
          timing = animate.gen_timing.linear({ duration = 150, unit = 'total' }),
          subscroll = animate.gen_subscroll.equal({
            predicate = function(total)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total > 1
            end,
          }),
        },
      }
    end,
  },
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
        function()
          require('mini.bufremove').delete(0, true)
        end,
        desc = 'Delete Buffer (Forced)',
      },
    },
  },
  -- Active indent guide and indent text objects. When you're browsing
  -- code, this highlights the current level of indentation, and animates
  -- the highlighting.
  {
    'echasnovski/mini.indentscope',
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = 'VeryLazy',
    opts = {
      symbol = '▏',
      -- symbol = '│',
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'help',
          'alpha',
          'dashboard',
          'neo-tree',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    'echasnovski/mini.surround',
    version = false,
    keys = function(self)
      local opts = self.opts
      local mappings = {
        { opts.mappings.add, desc = 'Add surrounding', mode = { 'n', 'v' } },
        { opts.mappings.delete, desc = 'Delete surrounding' },
        { opts.mappings.find, desc = 'Find right surrounding' },
        { opts.mappings.find_left, desc = 'Find left surrounding' },
        { opts.mappings.highlight, desc = 'Highlight surrounding' },
        { opts.mappings.replace, desc = 'Replace surrounding' },
        { opts.mappings.update_n_lines, desc = 'Update `MiniSurround.config.n_lines`' },
      }

      return mappings
    end,
    opts = {
      mappings = {
        add = 'gsa',
        delete = 'gsd', -- Delete surrounding
        find = 'gsf', -- Find surrounding (to the right)
        find_left = 'gsF', -- Find surrounding (to the left)
        highlight = 'gsh', -- Highlight surrounding
        replace = 'gsr', -- Replace surrounding
        update_n_lines = 'gsn', -- Update `n_lines`
      },
    },
  },
  {
    'echasnovski/mini.ai',
    version = false,
    event = 'VeryLazy',
  }
}

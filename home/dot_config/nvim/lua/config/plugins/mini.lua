---@type LazySpec
return {
  {
    'echanovski/mini.animate',
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
        '<leader>bD', function() require('mini.bufremove').delete(0, true) end, desc = 'Delete Buffer (Forced)',
      },
    },
  },
}

---@type LazySpec
return {
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { 'dashboard' },
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
      },
      extensions = { 'neo-tree', 'lazy' },
    },
  },
}

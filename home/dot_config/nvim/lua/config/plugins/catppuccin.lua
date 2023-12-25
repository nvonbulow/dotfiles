---@type LazySpec
return {
  -- Only the best color scheme ever
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('catppuccin')
    end,
  }
}

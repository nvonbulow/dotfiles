---@type LazySpec
return {
  'dstein64/nvim-scrollview',
  -- TODO: BufReadPost and BufNewFile don't account for restoring a session from the dashboard
  -- event = { 'BufReadPost', 'BufNewFile' },
  event = 'VeryLazy',
  ---@type ScrollbarOptions
  opts = {
    excluded_filetypes = { 'nerdtree' },
    current_only = true,
    base = 'right',
    -- column = 80,
    signs_on_startup = { 'all' },
    diagnostics_severities = { vim.diagnostic.severity.ERROR },
  },
}

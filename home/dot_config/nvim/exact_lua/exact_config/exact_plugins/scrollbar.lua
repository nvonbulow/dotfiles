---@type LazySpec
return {
  'petertriho/nvim-scrollbar',
    -- TODO: BufReadPost and BufNewFile don't account for restoring a session from the dashboard
  -- event = { 'BufReadPost', 'BufNewFile' },
  event = 'VeryLazy',
  ---@type ScrollbarOptions
  opts = {
    set_highlights = false,
    handlers = {
      gitsigns = true,
    }
  },
}

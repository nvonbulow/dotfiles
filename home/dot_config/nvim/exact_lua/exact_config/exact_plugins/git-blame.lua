---@type LazySpec
return {
  'FabijanZulj/blame.nvim',
  event = 'VeryLazy',
  config = function(self, opts)
    require('blame').setup(opts)
  end,
  opts = function()
    return {
      date_format = '%d.%m.%Y',
      virtual_style = 'right',
      views = {
        window  = require('blame.views.window_view'),
        virtual = require('blame.views.virtual_view'),
        default = require('blame.views.window_view'),
      },
      merge_consecutive = false,
      max_summary_width = 30,
      colors = nil,
      commit_detail_view = 'vsplit',
      format_fn = require('blame.formats.default_formats').commit_detail_view,
      mappings = {
        commit_info = 'i',
        stack_push = '<TAB>',
        stack_pop = '<BS>',
        show_commit = '<CR>',
        close = { '<esc>', 'q' },
      },
    }
  end,
}

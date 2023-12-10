return {
  { import = "lazyvim.plugins.extras.ui.mini-animate" },
  -- window picker plugin
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup()
    end,
  },

  -- toggleable terminal widget
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    config = true,
    keys = {
      {
        "<leader>wt",
        "<cmd>ToggleTerm dir=%:p:h<cr>",
        desc = "Toggle terminal",
      },
    },
  },

  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  -- Always show bufferline tabs
  { "akinsho/bufferline.nvim", opts = { options = { always_show_bufferline = true } } },

  {
    "telescope.nvim",
    dependencies = {

      {
        "tiagovla/scope.nvim",
        config = function(_, opts)
          require("scope").setup(opts)
          require("telescope").load_extension("scope")
        end,
      },
    },
  },
}

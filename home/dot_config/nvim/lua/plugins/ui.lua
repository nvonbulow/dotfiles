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

  -- plugin to move windows around
  {
    "sindrets/winshift.nvim",
    event = "VeryLazy",
    config = true,
    keys = {
      {
        "<leader>wsh",
        "<cmd>WinShift left<cr>",
        desc = "Shift window left",
      },
      {
        "<leader>wsj",
        "<cmd>WinShift down<cr>",
        desc = "Shift window down",
      },
      {
        "<leader>wsk",
        "<cmd>WinShift up<cr>",
        desc = "Shift window up",
      },
      {
        "<leader>wsl",
        "<cmd>WinShift right<cr>",
        desc = "Shift window right",
      },
      {
        "<leader>wsH",
        "<cmd>WinShift far_left<cr>",
        desc = "Shift window far left",
      },
      {
        "<leader>wsJ",
        "<cmd>WinShift far_down<cr>",
        desc = "Shift window far down",
      },
      {
        "<leader>wsK",
        "<cmd>WinShift far_up<cr>",
        desc = "Shift window far up",
      },
      {
        "<leader>wsL",
        "<cmd>WinShift far_right<cr>",
        desc = "Shift window far right",
      },
    },
  },
  -- add description for whichkey
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      defaults = {
        ["<leader>ws"] = { name = "+shift" },
      },
    },
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
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
      },
    },
  },

  -- integration with tmux
  {
    "christoomey/vim-tmux-navigator",
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to left window" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to lower window" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to upper window" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to right window" },
    },
  },
}

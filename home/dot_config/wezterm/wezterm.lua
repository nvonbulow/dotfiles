local wezterm = require("wezterm")

local function get_config()
  local config = {}
  if wezterm.config_builder then
    config = wezterm.config_builder()
  end
  -- font settings
  config.font = wezterm.font("SpaceMono Nerd Font")
  config.font_size = 13.5
  -- disable ligatures ->
  config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
  config.underline_position = "-0.2cell"
  config.underline_thickness = "0.1cell"
  config.line_height = 1.2

  config.term = "wezterm"

  -- set theme
  config.color_scheme = "Catppuccin Mocha"

  config.hide_tab_bar_if_only_one_tab = true

  return config
end

return get_config()

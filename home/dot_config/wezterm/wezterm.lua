local wezterm = require("wezterm")

local function get_config()
  local config = {}
  if wezterm.config_builder then
    config = wezterm.config_builder()
  end
  -- font settings
  config.font = wezterm.font("SpaceMono Nerd Font")
  config.font_size = 18
  -- disable ligatures ->
  config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
  config.underline_position = "-0.2cell"
  config.underline_thickness = "0.1cell"
  -- config.line_height = 1.2

  config.term = "wezterm"

  -- set theme
  config.color_scheme = "Catppuccin Mocha"

  config.hide_tab_bar_if_only_one_tab = true

  return config
end

wezterm.on('user-var-changed', function(window, pane, name, value)
  local overrides = window:get_config_overrides() or {}
  if name == "ZEN_MODE" then
    local incremental = value:find("+")
    local number_value = tonumber(value)
    if incremental ~= nil then
      while (number_value > 0) do
        window:perform_action(wezterm.action.IncreaseFontSize, pane)
        number_value = number_value - 1
      end
      overrides.enable_tab_bar = false
    elseif number_value < 0 then
      window:perform_action(wezterm.action.ResetFontSize, pane)
      overrides.font_size = nil
      overrides.enable_tab_bar = true
    else
      overrides.font_size = number_value
      overrides.enable_tab_bar = false
    end
  end
  window:set_config_overrides(overrides)
end)

return get_config()

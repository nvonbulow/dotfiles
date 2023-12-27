local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- font settings
config.font = wezterm.font("SpaceMono Nerd Font")
config.font_size = 14.0
-- disable ligatures ->
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

config.term = "wezterm"

-- set theme
config.color_scheme = "Catppuccin Mocha"

return config

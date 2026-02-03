-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrainsMono NF")
config.default_prog = { "tmux", "new", "-A", "-s", "main" }
config.enable_tab_bar = false
return config

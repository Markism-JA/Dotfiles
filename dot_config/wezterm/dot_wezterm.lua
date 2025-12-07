local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.default_prog = { "pwsh.exe" }
config.font = wezterm.font("JetBrains Mono")
config.font_size = 13
config.color_scheme = "Oxocarbon Dark"

return config

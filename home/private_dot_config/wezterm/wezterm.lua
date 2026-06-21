local wezterm = require "wezterm"

local config = {}

if wezterm.config_builder then config = wezterm.config_builder() end

config.keys = {
    {
        key = "E",
        mods = "CTRL",
        action = wezterm.action.QuickSelectArgs {
            label = "open url",
            patterns = {
                "https?://\\S+",
            },
            action = wezterm.action_callback(function(window, pane)
                local url = window:get_selection_text_for_pane(pane)
                wezterm.log_info("opening: " .. url)
                wezterm.open_with(url)
            end),
        },
    },
}

config.enable_tab_bar = false
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
config.color_scheme = "tokyonight"
-- window buttons like close, maximize, etc.
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

config.font = wezterm.font_with_fallback {
    -- "JetBrains Mono",
    "Cascadia Code",
    -- "Fira Code",
    -- "Hack",
    -- "Source Code Pro",
    "Noto Color Emoji",
    { family = "Symbols Nerd Font Mono", scale = 0.75 }, -- Set scale otherwise some icons look to big
}

return config

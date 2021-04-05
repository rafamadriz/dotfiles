require("config")

C = Theming.colorscheme:gsub("%s+", "")
CS = Theming.colorscheme_style:gsub("%s+", "")

if C == "" or C == nil then
    C = "edge"
end

local styles = {
    edge = {
        "default",
        "aura",
        "neon"
    },
    gruvbox = {
        "medium",
        "soft",
        "hard"
    },
    sonokai = {
        "default",
        "atlantis",
        "andromeda",
        "shusia",
        "maia"
    }
}

local function check_theme(theme)
    local style
    if theme == "edge" then
        style = styles.edge
    elseif theme == "gruvbox" then
        style = styles.gruvbox
    elseif theme == "sonokai" then
        style = styles.sonokai
    end
    if style ~= nil then
        if CS == "" or CS == nil then
            CS = style[1]
        end
    end
end
check_theme(C)
--[[ local function check_themes(theme)
    for i, k in pairs(styles) do
        if i == theme then
            table = styles[i]
        end
    end
    print(table)
    local default_style
    default_style = table[1]
    if default_style ~= nil then
        if CS == "" or CS == nil then
            CS = default_style
        end
    end
end
check_themes(C) ]]
--[[ local function has_style(index, theme)
    if index == theme then
        Style = true
    end
    return Style
end

local function check_style(theme)
    for i, k in pairs(styles) do
        has_style(i, theme)
        if Style == true then
            table = styles[i]
            local default_style
            default_style = table[1]
            if CS == "" or CS == nil then
                CS = default_style
            end
        end
    end
end
check_style(C) ]]

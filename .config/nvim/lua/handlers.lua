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
    if CS == "" or CS == nil then
        CS = style[1]
    end
end
check_theme(C)

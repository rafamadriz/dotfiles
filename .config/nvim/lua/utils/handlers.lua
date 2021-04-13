-- Auto install plugin manager if doesn't exist
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    execute "packadd packer.nvim"
end

-- Theming
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

if Theming.colorscheme == nil or Theming.colorscheme:gsub("%s+", "") == "" then
    C = "edge"
else
    C = Theming.colorscheme:gsub("%s+", "")
end

if Theming.colorscheme_style ~= nil then
    CS = Theming.colorscheme_style:gsub("%s+", "")
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
else
    CS = ""
end

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
-- LSP

local servers = {"bash", "clangd", "css", "emmet", "json", "lua", "python", "tsserver"}

for _, v in pairs(servers) do
    if LSP[v] == nil then
        LSP[v] = false
    end
end

-- Completion
if Completion.items < 1 or Completion.items == nil then
    Completion.items = 15
end

if Completion.enabled == nil then
    Completion.enabled = true
end

if Completion.snippets == nil or Completion.snippets == true then
    Completion.snippets = {kind = " ﬌ (Snippet)"}
end

if Completion.lsp == nil or Completion.lsp == true then
    Completion.lsp = {kind = "  "}
end

if Completion.buffer == nil or Completion.buffer == true then
    Completion.buffer = {kind = "  (Buffer)"}
end

if Completion.path == nil or Completion.path == true then
    Completion.path = {kind = "  (Path)"}
end

if Completion.calc == nil or Completion.calc == true then
    Completion.calc = {kind = "  (Calc)"}
end

if Completion.spell == nil or Completion.spell == true then
    Completion.spell = {kind = "  (Spell)"}
end

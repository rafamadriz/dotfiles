-- Auto install plugin manager if doesn't exist
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    execute "packadd packer.nvim"
end

-- Theming
local default = "gruvbox"
local colors = vim.fn.getcompletion("", "color")

local function default_theme(t, s)
    if s == nil or s:gsub("%s+", "") == "" then
        return default
    else
        s = s:gsub("%s+", "")
    end
    for _, v in pairs(t) do
        if v == s then
            return s
        end
    end
    return "default"
end

local function fellback_CS(check)
    local v
    if check ~= nil then
        v = check:gsub("%s+", "")
    else
        v = ""
    end
    return v
end

C = default_theme(colors, Theming.colorscheme)
CS = fellback_CS(Theming.colorscheme_style)

-- LSP

local servers = {"bash", "clangd", "css", "emmet", "json", "lua", "python", "tsserver", "html", "latex"}

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

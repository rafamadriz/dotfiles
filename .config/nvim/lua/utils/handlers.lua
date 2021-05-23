-- Theming
local default = "neon"
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

local function color_style_or_empty(check)
    local v
    if check ~= nil then
        v = check:gsub("%s+", "")
    else
        v = ""
    end
    return v
end

C = default_theme(colors, Theming.colorscheme)
CS = color_style_or_empty(Theming.colorscheme_style)

local function compe_menu(source, str, src, prio, ft)
    if source == nil or source == true then
        if ft == nil then
            return {kind = str, menu = src, priority = prio}
        elseif prio == nil and ft == nil then
            return {kind = str, menu = src}
        elseif str == nil and prio == nil then
            return {menu = src, filetypes = ft}
        elseif str == nil and prio == nil and ft == nil then
            return {menu = str}
        end
    end
    return false
end

Completion.buffer = compe_menu(Completion.buffer, "  (Buffer)", "[B]", nil, nil)
Completion.spell = compe_menu(Completion.spell, "  (Spell)", "[E]", nil, nil)
Completion.path = compe_menu(Completion.path, "  (Path)", nil, nil, nil)
Completion.calc = compe_menu(Completion.calc, "  (Calc)", "[C]", nil, nil)
Completion.snippets = compe_menu(Completion.snippets, " ﬌  (Snippet)", "[S]", 1500, nil)
Completion.emoji = compe_menu(Completion.emoji, nil, "[ ﲃ ]", nil, {"markdown", "text"})
Completion.lsp = compe_menu(Completion.lsp, nil, "[L]", nil, nil)

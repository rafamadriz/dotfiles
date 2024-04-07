-- source: https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
local modes = {
    ["n"] = "NORMAL",
    ["no"] = "NORMAL",
    ["v"] = "VISUAL",
    ["V"] = "V-LINE",
    [""] = "V-BLOCK",
    ["s"] = "SELECT",
    ["S"] = "S-LINE",
    [""] = "S-BLOCK",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rv"] = "V-REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "VIM EX",
    ["ce"] = "EX",
    ["r"] = "PROMPT",
    ["rm"] = "MOAR",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERMINAL",
}

local function mode()
    local current_mode = vim.api.nvim_get_mode().mode
    return string.format(" %s ", modes[current_mode]):upper()
end

local function update_mode_colors()
    local current_mode = vim.api.nvim_get_mode().mode
    local mode_color
    if current_mode == "n" then
        mode_color = "%#MiniStatuslineModeNormal#"
    elseif current_mode == "i" or current_mode == "ic" then
        mode_color = "%#MiniStatuslineModeInsert#"
    elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
        mode_color = "%#MiniStatuslineModeVisual#"
    elseif current_mode == "R" then
        mode_color = "%#MiniStatuslineModeReplace#"
    elseif current_mode == "c" then
        mode_color = "%#MiniStatuslineModeCommand#"
    else
        mode_color = "%#MiniStatuslineModeOther#"
    end
    return mode_color
end

local function filepath()
    local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
    if fpath == "" or fpath == "." then return " " end

    return string.format(" %%<%s/", fpath)
end

local function filename()
    local fname = vim.fn.expand "%:t"
    if vim.bo.modified then fname = fname .. "[+]" end
    if fname == "" then return "" end
    return fname .. " "
end

local function lsp()
    local count = {}
    local levels = {
        errors = "Error",
        warnings = "Warn",
        info = "Info",
        hints = "Hint",
    }

    for k, level in pairs(levels) do
        count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
    end

    local errors = ""
    local warnings = ""
    local hints = ""
    local info = ""

    if count["errors"] ~= 0 then errors = " %#DiagnosticError#E:" .. count["errors"] end
    if count["warnings"] ~= 0 then warnings = " %#DiagnosticWarn#W:" .. count["warnings"] end
    if count["hints"] ~= 0 then hints = " %#DiagnosticHint#H:" .. count["hints"] end
    if count["info"] ~= 0 then info = " %#DiagnosticInfo#I:" .. count["info"] end

    return errors .. warnings .. hints .. info .. "%#Normal#"
end

local function filetype() return string.format("  %s ", vim.bo.filetype):upper() end

local function lineinfo()
    if vim.bo.filetype == "alpha" then return "" end
    return " %P %l:%c "
end

local vcs = function()
    local git_info = vim.b.gitsigns_status_dict
    if not git_info or git_info.head == "" then return "" end
    local added = git_info.added and ("%#GitSignsAdd#+" .. git_info.added .. " ") or ""
    local changed = git_info.changed and ("%#GitSignsChange#~" .. git_info.changed .. " ") or ""
    local removed = git_info.removed and ("%#GitSignsDelete#-" .. git_info.removed .. " ") or ""
    if git_info.added == 0 then added = "" end
    if git_info.changed == 0 then changed = "" end
    if git_info.removed == 0 then removed = "" end
    return table.concat {
        " ",
        added,
        changed,
        removed,
        " ",
        "%#GitSignsAdd# ",
        git_info.head,
        " %#Normal#",
    }
end

Statusline = {}
Statusline.active = function()
    return table.concat {
        "%#StatusLine#",
        update_mode_colors(),
        mode(),
        "%#Normal# ",
        filepath(),
        filename(),
        "%#Normal#",
        vcs(),
        "%=%#StatusLineExtra#",
        lsp(),
        filetype(),
        lineinfo(),
    }
end

local aucmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

aucmd({ "WinEnter", "BufEnter" }, {
    pattern = "*",
    group = augroup("Statusline", { clear = true }),
    command = "setlocal statusline=%!v:lua.Statusline.active()",
})

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

local function get_color(hl_group, color)
    local hl = vim.api.nvim_get_hl(0, { name = hl_group })
    local decimal_color = hl[color]
    return string.format("#%x", decimal_color)
end

local c = {
    normal_bg = get_color("StatusLine", "bg"),
    mode = get_color("CursorLine", "bg"),
    diff_add = get_color("DiffAdded", "fg"),
    diff_change = get_color("DiffChanged", "fg"),
    diff_delete = get_color("DiffDeleted", "fg"),
    git_head = get_color("DiagnosticInfo", "fg"),
    diganostic_error = get_color("DiagnosticError", "fg"),
    diganostic_warn = get_color("DiagnosticWarn", "fg"),
    diganostic_hint = get_color("DiagnosticHint", "fg"),
    diganostic_info = get_color("DiagnosticInfo", "fg"),
}

local function create_hl(name, opts)
    if not opts.bg then opts.bg = c.normal_bg end
    if not opts.bold then opts.bold = true end
    vim.api.nvim_set_hl(0, name, opts)
end

local highlight_groups = {
    StDiffAdd = { fg = c.diff_add },
    StDiffChange = { fg = c.diff_change },
    StDiffDelete = { fg = c.diff_delete },
    StGitHead = { fg = c.git_head },
    StNormal = { bg = c.normal_bg },
    StNormalBold = { bg = c.normal_bg },
    StMode = { bg = c.mode },
    StDiagnosticError = { fg = c.diganostic_error },
    StDiagnosticWarn = { fg = c.diganostic_warn },
    StDiagnosticHint = { fg = c.diganostic_hint },
    StDiagnosticInfo = { fg = c.diganostic_info },
}

for group, param in pairs(highlight_groups) do
    create_hl(group, param)
end

local function mode()
    local current_mode = vim.api.nvim_get_mode().mode
    return string.format("  %-8s", modes[current_mode]):upper()
end

local function filepath(opts)
    local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
    if fpath == "" or fpath == "." then return " " end

    local vowels = "AEIOUaeiou"
    local function remove_vowels(str)
        if #str > 4 then
            for c in vowels:gmatch "." do
                str = string.sub(str, 1, 1) == c and str:gsub(c, c) or str:gsub(c, "")
            end
        end
        return str
    end

    if opts.remove_vowels then fpath = remove_vowels(fpath) end
    return string.format(" %%<%s/", fpath)
end

local function is_modified()
    if vim.bo.modified then return "•" end
    return " "
end

local function filename()
    local file_name = vim.fn.expand "%:t"
    if file_name == "" then return " " end

    return file_name
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

    if count["errors"] ~= 0 then errors = " %#StDiagnosticError#E:" .. count["errors"] end
    if count["warnings"] ~= 0 then warnings = " %#StDiagnosticWarn#W:" .. count["warnings"] end
    if count["hints"] ~= 0 then hints = " %#StDiagnosticHint#H:" .. count["hints"] end
    if count["info"] ~= 0 then info = " %#StDiagnosticInfo#I:" .. count["info"] end

    return errors .. warnings .. hints .. info .. "%#StatusLine#"
end

local function filetype() return string.format("  %s ", vim.bo.filetype):upper() end

local function lineinfo()
    local pos = vim.fn.getcurpos()
    local line = pos[2]
    local column = pos[3]
    local height = vim.api.nvim_buf_line_count(0)

    local str = " "
    local padding = #tostring(height) - #tostring(line)
    if padding > 0 then str = str .. (" "):rep(padding) end

    str = str .. "ℓ "
    str = str .. line
    str = str .. " c "
    str = str .. column
    str = str .. " "

    if #tostring(column) < 2 then str = str .. " " end
    return str
end

local vcs = function()
    local git_info = vim.b.gitsigns_status_dict
    if not git_info or git_info.head == "" then return "" end
    local added = git_info.added and ("%#StDiffAdd#+" .. git_info.added .. " ") or ""
    local changed = git_info.changed and ("%#StDiffChange#~" .. git_info.changed .. " ") or ""
    local removed = git_info.removed and ("%#StDiffDelete#-" .. git_info.removed .. " ") or ""
    if git_info.added == 0 then added = "" end
    if git_info.changed == 0 then changed = "" end
    if git_info.removed == 0 then removed = "" end
    return table.concat {
        " ",
        added,
        changed,
        removed,
        " ",
        "%#StGitHead#",
        git_info.head,
        " %#StatusLine#",
    }
end

Statusline = {}
Statusline.active = function()
    return table.concat {
        "%#StMode#",
        mode(),
        "%#StNormal#",
        filepath { remove_vowels = true },
        filename(),
        is_modified(),
        "%#StatusLine#",
        vcs(),
        "%=%#StatusLineExtra#",
        lsp(),
        "%#StNormal#",
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

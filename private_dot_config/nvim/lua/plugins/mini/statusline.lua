local M = {}

local mini_statusline = require "mini.statusline"

local groups = function()
    local mode, mode_hl = mini_statusline.section_mode { trunc_width = 120 }
    local git = mini_statusline.section_git { trunc_width = 40 }
    local diff = mini_statusline.section_diff { trunc_width = 75 }

    local create_hl = function(severity)
        vim.api.nvim_set_hl(0, "MiniStatuslineDiagnostic" .. severity, {
            bg = vim.api.nvim_get_hl(0, { name = "MiniStatuslineFilename" }).bg,
            fg = vim.api.nvim_get_hl(0, { name = "Diagnostic" .. severity }).fg,
            bold = true,
        })
    end

    for _, severity in pairs { "Error", "Warn", "Info", "Hint" } do
        create_hl(severity)
    end

    local diag_signs = {
        ERROR = "%#MiniStatuslineDiagnosticError#E:",
        WARN = "%#MiniStatuslineDiagnosticWarn#W:",
        INFO = "%#MiniStatuslineDiagnosticInfo#I:",
        HINT = "%#MiniStatuslineDiagnosticHint#H:",
    }
    -- Compute colored diagnostics and reset color for later LSP section
    local diagnostics = mini_statusline.section_diagnostics { trunc_width = 75, signs = diag_signs }
    diagnostics = diagnostics .. "%#MiniStatuslineFilename#"

    local filename = mini_statusline.section_filename { trunc_width = 140 }
    local fileinfo = string.format("%s | %s", vim.opt.fileencoding:get(), vim.bo.fileformat)

    local location = function()
        local pos = vim.fn.getcurpos()
        local line, column = pos[2], pos[3]
        local height = vim.api.nvim_buf_line_count(0)

        local str = " "
        local padding = #tostring(height) - #tostring(line)
        if padding > 0 then
            str = str .. (" "):rep(padding)
        end

        str = str .. "ℓ "
        str = str .. line
        str = str .. " c "
        str = str .. column
        str = str .. " "

        if #tostring(column) < 2 then
            str = str .. " "
        end
        return str
    end

    local search = mini_statusline.section_searchcount { trunc_width = 75 }
    return mini_statusline.combine_groups {
        { hl = mode_hl, strings = { mode } },
        { hl = "MiniStatuslineDevinfo", strings = { git, diff } },
        "%<", -- Mark general truncate point
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=", -- End left alignment
        { hl = "MiniStatuslineFilename", strings = { diagnostics } },
        { hl = "MiniStatuslineFileInfo", strings = { fileinfo } },
        { hl = mode_hl, strings = { search, location() } },
    }
end

M.setup = function()
    mini_statusline.setup {
        content = { active = groups },
    }
end

return M

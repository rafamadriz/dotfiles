local M = {}

M.ai = function()
    local ai = require "mini.ai"
    require("mini.ai").setup {
        n_lines = 500,
        mappings = { around_last = "", inside_last = "" },
        custom_textobjects = {
            i = ai.gen_spec.treesitter({ a = "@conditional.outer", i = "@conditional.inner" }, {}),
            f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
            c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
    }
end

M.operators = function()
    require("mini.operators").setup {
        exchange = { prefix = "gx" },
        replace = { prefix = "gX" },
        multiply = { prefix = "" },
        sort = { prefix = "" },
        evaluate = { prefix = "" },
    }
end

M.notify = function()
    local notify = require "mini.notify"
    notify.setup {}
    vim.api.nvim_create_user_command("Mes", function() notify.show_history() end, {})
    vim.notify = notify.make_notify()
end

M.git = function()
    local git = require "mini.git"
    git.setup {}
    vim.cmd.cnoreabbrev "G Git"

    vim.api.nvim_create_autocmd("Filetype", {
        pattern = { "git", "diff" },
        callback = function(args)
            if not vim.api.nvim_buf_is_valid(args.buf) then return end
            local buf_name = vim.api.nvim_buf_get_name(args.buf)
            if not vim.startswith(buf_name, "minigit://") then return end

            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.MiniGit.diff_foldexpr()"

            vim.keymap.set({ "n", "x" }, "K", git.show_at_cursor, { buffer = args.buf, desc = "Show git data" })
            vim.keymap.set({ "n", "x" }, "gd", git.show_diff_source, { buffer = args.buf, desc = "Go to git source" })
        end,
    })
end

M.statusline = function()
    local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
    local git = MiniStatusline.section_git { trunc_width = 40 }
    local diff = MiniStatusline.section_diff { trunc_width = 75 }

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
    local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75, signs = diag_signs }
    diagnostics = diagnostics .. "%#MiniStatuslineFilename#"

    local filename = MiniStatusline.section_filename { trunc_width = 140 }
    local fileinfo = string.format("%s | %s", vim.opt.fileencoding:get(), vim.bo.fileformat)

    local location = function()
        local pos = vim.fn.getcurpos()
        local line, column = pos[2], pos[3]
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

    local search = MiniStatusline.section_searchcount { trunc_width = 75 }

    return MiniStatusline.combine_groups {
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

return {
    {
        "echasnovski/mini.nvim",
        lazy = false,
        version = false,
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        config = function()
            M.ai()
            M.operators()
            M.notify()
            M.git()
            require("mini.align").setup {}
            require("mini.icons").setup {}
            require("mini.statusline").setup {
                content = { active = M.statusline },
            }
        end,
    },
}

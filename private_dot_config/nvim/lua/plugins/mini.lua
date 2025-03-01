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

M.files = function()
    local files = require "mini.files"
    files.setup {
        options = {
            -- Whether to delete permanently or move into module-specific trash
            permanent_delete = false,
        },
        windows = {
            -- Whether to show preview of file/directory under cursor
            preview = true,
        },
    }

    local files_toggle = function()
        if not files.close() then files.open() end
    end

    vim.keymap.set("n", "<leader>e", files_toggle, { desc = "File explorer" })
    vim.keymap.set(
        "n",
        "<leader>E",
        function() files.open(vim.api.nvim_buf_get_name(0)) end,
        { desc = "File explorer" }
    )

    -- Create mapping to shoe/hide dot-files
    local show_dotfiles = true

    local filter_show = function() return true end

    local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, ".") end

    local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        files.refresh { content = { filter = new_filter } }
    end

    vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
            local buf_id = args.data.buf_id
            -- Tweak left-hand side of mapping to your liking
            vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Toggle hidden" })
        end,
    })

    -- Create mappings to modify target window via split ~
    local map_split = function(buf_id, lhs, direction)
        local rhs = function()
            -- Make new window and set it as target
            local cur_target = files.get_explorer_state().target_window
            local new_target = vim.api.nvim_win_call(cur_target, function()
                vim.cmd(direction .. " split")
                return vim.api.nvim_get_current_win()
            end)

            files.set_target_window(new_target)

            -- This intentionally doesn't act on file under cursor in favor of
            -- explicit "go in" action (`l` / `L`). To immediately open file,
            -- add appropriate `MiniFiles.go_in()` call instead of this comment.
            files.go_in()
        end

        -- Adding `desc` will result into `show_help` entries
        local desc = "Split " .. direction
        vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
    end

    vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
            local buf_id = args.data.buf_id
            -- Tweak keys to your liking
            map_split(buf_id, "<C-s>", "belowright horizontal")
            map_split(buf_id, "<C-v>", "belowright vertical")
        end,
    })

    -- Set focused directory as current working directory
    local set_cwd = function()
        local path = (files.get_fs_entry() or {}).path
        if path == nil then return vim.notify "Cursor is not on valid entry" end
        vim.fn.chdir(vim.fs.dirname(path))
    end

    -- Yank in register full path of entry under cursor
    local yank_path = function()
        local path = (files.get_fs_entry() or {}).path
        if path == nil then return vim.notify "Cursor is not on valid entry" end
        vim.fn.setreg(vim.v.register, path)
    end

    -- run shell command on entry under cursor
    local run_cmd = function()
        local ok, input = pcall(vim.fn.input, { prompt = "command: ", completion = "shellcmd" })
        if ok then
            if input == "" then return vim.notify "Command cannot be empty" end
            vim.api.nvim_command(":! " .. input .. ' "' .. files.get_fs_entry().path .. '"')
        end
    end

    -- Open file with system utlity
    local xdg_open = function()
        local path = (files.get_fs_entry() or {}).path
        if path == nil then return vim.notify "Cursor is not on valid entry" end
        os.execute("xdg-open " .. path)
    end

    vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
            local b = args.data.buf_id
            vim.keymap.set("n", "g~", set_cwd, { buffer = b, desc = "Set cwd" })
            vim.keymap.set("n", "gy", yank_path, { buffer = b, desc = "Yank path" })
            vim.keymap.set("n", "g:", run_cmd, { buffer = b, desc = "Run shell cmd on entry" })
            vim.keymap.set("n", "gx", xdg_open, { buffer = b, desc = "Open with system utility" })
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
            M.files()
            require("mini.align").setup {}
            require("mini.icons").setup {}
            require("mini.animate").setup()
            require("mini.statusline").setup {
                content = { active = M.statusline },
            }
        end,
    },
}

local M = {}

local files = require "mini.files"

-- Create mapping to shoe/hide dot-files
local show_dotfiles = true

local filter_show = function() return true end

local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, ".") end

local toggle_dotfiles = function()
    show_dotfiles = not show_dotfiles
    local new_filter = show_dotfiles and filter_show or filter_hide
    files.refresh { content = { filter = new_filter } }
end

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

local open_trash = function()
    local trash = vim.fn.stdpath "data" .. "/mini.files/trash"
    files.open(trash)
end

M.setup = function()
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

    vim.keymap.set("n", "<leader>e", function()
        if not files.close() then files.open(vim.api.nvim_buf_get_name(0)) end
    end, { desc = "File explorer" })

    vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
            local buf_id = args.data.buf_id
            -- Tweak left-hand side of mapping to your liking
            vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Toggle hidden" })
        end,
    })

    vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
            local buf_id = args.data.buf_id
            -- Tweak keys to your liking
            map_split(buf_id, "<C-s>", "belowright horizontal")
            map_split(buf_id, "<C-v>", "belowright vertical")
        end,
    })

    vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
            local b = args.data.buf_id
            vim.keymap.set("n", "g~", set_cwd, { buffer = b, desc = "Set cwd" })
            vim.keymap.set("n", "gy", yank_path, { buffer = b, desc = "Yank path" })
            vim.keymap.set("n", "g:", run_cmd, { buffer = b, desc = "Run shell cmd on entry" })
            vim.keymap.set("n", "gx", xdg_open, { buffer = b, desc = "Open with system utility" })
            vim.keymap.set("n", "g\\", open_trash, { buffer = b, desc = "Open trash folder" })
        end,
    })
end

return M

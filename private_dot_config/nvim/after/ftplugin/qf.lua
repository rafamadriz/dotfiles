-- source: https://github.com/famiu/dot-nvim/blob/master/ftplugin/qf.lua
-- author: @famiu
local function RemoveQuickFixEntry()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local qflist = vim.fn.getqflist()

    -- Remove line from qflist.
    table.remove(qflist, line)
    vim.fn.setqflist(qflist, "r")

    -- Restore cursor position.
    local max_lines = vim.api.nvim_buf_line_count(0)
    vim.api.nvim_win_set_cursor(0, { math.min(line, max_lines), 0 })
end

-- Allow easily removing quickfix items.
vim.keymap.set("n", "dd", RemoveQuickFixEntry, { buffer = 0, silent = true })

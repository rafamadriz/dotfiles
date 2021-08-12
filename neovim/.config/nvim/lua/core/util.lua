local M = {}

local cmd = vim.cmd
local fn = vim.fn

-- automatically creates missing directories when saving a file
function M.mkdir()
    local dir = fn.expand "%:p:h"

    if fn.isdirectory(dir) == 0 then
        fn.mkdir(dir, "p")
    end
end

-- delete buffers and preserve window layout.
M.delete_buffer = function()
    local buflisted = fn.getbufinfo { buflisted = 1 }
    local cur_winnr, cur_bufnr = fn.winnr(), fn.bufnr()
    if #buflisted < 2 then
        cmd "confirm qall"
        return
    end
    for _, winid in ipairs(fn.getbufinfo(cur_bufnr)[1].windows) do
        cmd(string.format("%d wincmd w", fn.win_id2win(winid)))
        cmd(cur_bufnr == buflisted[#buflisted].bufnr and "bp" or "bn")
    end
    cmd(string.format("%d wincmd w", cur_winnr))
    local is_terminal = fn.getbufvar(cur_bufnr, "&buftype") == "terminal"
    cmd(is_terminal and "bd! #" or "silent! confirm bd #")
end

-- tmux like <C-b>z: focus on one buffer in extra tab
-- put current window in new tab with cursor restored
M.buf_to_tab = function()
    -- skip if there is only one window open
    if vim.tbl_count(vim.api.nvim_tabpage_list_wins(0)) == 1 then
        print "Cannot expand single buffer"
        return
    end

    local buf = vim.api.nvim_get_current_buf()
    local view = fn.winsaveview()
    -- note: tabedit % does not properly work with terminal buffer
    cmd [[tabedit]]
    -- set buffer and remove one opened by tabedit
    local tabedit_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_buf_delete(tabedit_buf, { force = true })
    -- restore original view
    fn.winrestview(view)
end

-- expand or minimize current buffer in "actual" direction
-- this is useful as mapping ":resize 2" stand-alone might otherwise not be in
-- the right direction if mapped to ctrl-leftarrow or something related use
M.resize = function(vertical, margin)
    local cur_win = vim.api.nvim_get_current_win()
    -- go (possibly) right
    cmd(string.format("wincmd %s", vertical and "l" or "j"))
    local new_win = vim.api.nvim_get_current_win()

    -- determine direction cond on increase and existing right-hand buffer
    local not_last = not (cur_win == new_win)
    local sign = margin > 0
    -- go to previous window if required otherwise flip sign
    if not_last == true then
        cmd [[wincmd p]]
    else
        sign = not sign
    end

    sign = sign and "+" or "-"
    local dir = vertical and "vertical " or ""
    local _cmd = dir .. "resize " .. sign .. math.abs(margin) .. "<CR>"
    cmd(_cmd)
end

return M

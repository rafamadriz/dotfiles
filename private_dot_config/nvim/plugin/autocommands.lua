if not as then
    return
end

local api, fn = vim.api, vim.fn

as.augroup('TextYankHighlight', {
    {
        event = 'TextYankPost',
        pattern = '*',
        desc = "highlight text on yank",
        command = function()
            vim.highlight.on_yank({
                timeout = 300,
            })
        end,
    },
})

as.augroup('JumpToLastPosition', {
    {
        event = "BufReadPost",
        pattern = "*",
        command = [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]],
        desc = "jump to last cursor position when opening a file",
    }
})

----------------------------------------------------------------------------------------------------
-- Trim trailing white space
----------------------------------------------------------------------------------------------------
--source: https://github.com/mcauley-penney/tidy.nvim
--credits: mcauley-penney
as.augroup('TrimTrailing', {
    {
        event = "BufWritePre",
        pattern = "*",
        command = function()
            local pos = api.nvim_win_get_cursor(0)

            -- delete all whitespace
            vim.cmd([[:keepjumps keeppatterns %s/\s\+$//e]])

            -- delete all lines at end of buffer
            vim.cmd([[:keepjumps keeppatterns silent! 0;/^\%(\n*.\)\@!/,$d]])

            --[[
                if the row value in the original cursor
                position tuple is greater than the
                line count after empty line deletion
                (meaning that the cursor was inside of
                the group of empty lines at the end of
                the file when they were deleted), set
                the cursor row to the last line
            ]]

            -- get row count after line deletion
            local end_row = api.nvim_buf_line_count(0)

            if pos[1] > end_row then
                pos[1] = end_row
            end

            api.nvim_win_set_cursor(0, pos)
        end,
    }
})
----------------------------------------------------------------------------------------------------
-- Automatically create missing directories when saving file
----------------------------------------------------------------------------------------------------
--source: https://github.com/jghauser/mkdir.nvim
--credits: jghauser
as.augroup('Mkdir', {
    {
        event = "BufWritePre",
        pattern = "*",
        command = function()
            local dir = fn.expand('<afile>:p:h')

            if fn.isdirectory(dir) == 0 then
                fn.mkdir(dir, "p")
            end
        end,
        desc = "automatically create missing directories when saving file",
    }
})

----------------------------------------------------------------------------------------------------
-- HLSEARCH
----------------------------------------------------------------------------------------------------
--source: https://github.com/akinsho/dotfiles/blob/main/.config/nvim/plugin/autocommands.lua
--credits: akinsho
--[[
In order to get hlsearch working the way I like i.e. on when using /,?,N,n,*,#, etc. and off when
When I'm not using them, I need to set the following:
The mappings below are essentially faked user input this is because in order to automatically turn off
the search highlight just changing the value of 'hlsearch' inside a function does not work
read `:h nohlsearch`. So to have this work I check that the current mouse position is not a search
result, if it is we leave highlighting on, otherwise I turn it off on cursor moved by faking my input
using the expr mappings below.
This is based on the implementation discussed here:
https://github.com/neovim/neovim/issues/5581
--]]

vim.keymap.set({ 'n', 'v', 'o', 'i', 'c' }, '<Plug>(StopHL)', 'execute("nohlsearch")[-1]', { expr = true })

local function stop_hl()
    if vim.v.hlsearch == 0 or api.nvim_get_mode().mode ~= 'n' then
        return
    end
    api.nvim_feedkeys(api.nvim_replace_termcodes('<Plug>(StopHL)', true, true, true), 'm', false)
end

local function hl_search()
    local col = api.nvim_win_get_cursor(0)[2]
    local curr_line = api.nvim_get_current_line()
    local ok, match = pcall(fn.matchstrpos, curr_line, fn.getreg('/'), 0)
    if not ok then
        return vim.notify(match, 'error', { title = 'HL SEARCH' })
    end
    local _, p_start, p_end = unpack(match)
    -- if the cursor is in a search result, leave highlighting on
    if col < p_start or col > p_end then
        stop_hl()
    end
end

as.augroup('VimrcIncSearchHighlight', {
    {
        event = { 'CursorMoved' },
        command = function()
            hl_search()
        end,
    },
    {
        event = { 'InsertEnter' },
        command = function()
            stop_hl()
        end,
    },
    {
        event = { 'OptionSet' },
        pattern = { 'hlsearch' },
        command = function()
            vim.schedule(function()
                vim.cmd('redrawstatus')
            end)
        end,
    },
})

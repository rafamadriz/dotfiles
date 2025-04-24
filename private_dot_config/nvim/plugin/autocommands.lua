local aucmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

aucmd({ "TextYankPost" }, {
    pattern = "*",
    desc = "Highlight text on yank",
    group = augroup("TextHighlightYank", { clear = true }),
    callback = function() vim.highlight.on_yank { timeout = 250 } end,
})

local no_lastplace = {
    buftypes = {
        "quickfix",
        "nofile",
        "help",
        "terminal",
    },
    filetypes = {
        "gitcommit",
        "gitrebase",
    },
}

aucmd({ "BufReadPost" }, {
    pattern = "*",
    desc = "Jump to last place in files",
    group = augroup("JumpToLastPosition", { clear = true }),
    callback = function()
        if
            vim.fn.line [['"]] >= 1
            and vim.fn.line [['"]] <= vim.fn.line "$"
            and not vim.tbl_contains(no_lastplace.buftypes, vim.o.buftype)
            and not vim.tbl_contains(no_lastplace.filetypes, vim.o.filetype)
        then
            vim.cmd [[normal! g`" | zv]]
        end
    end,
})

aucmd({ "TermOpen" }, {
    pattern = "term://*",
    desc = "Start in insert mode in terminal",
    group = augroup("MyTerminalOps", { clear = true }),
    callback = function() vim.cmd "startinsert" end,
})

-- source: https://github.com/tsakirist/dotfiles/blob/7d3454a57679e5ba1c8ce4273bbed3eb737bb99c/nvim/lua/tt/autocommands.lua#L117-L142
aucmd("BufWritePre", {
    pattern = "*",
    desc = "Automatically create missing directories when saving file",
    group = augroup("Mkdir", { clear = true }),
    callback = function(event)
        ---Checks whether the autocommand should run
        ---@param path string
        ---@return boolean
        local function is_excluded(path)
            for _, pattern in ipairs { "^oil://" } do
                if path:find(pattern) then
                    return true
                end
            end
            return false
        end

        local full_path = event.match
        if is_excluded(full_path) then
            return
        end

        local directory = vim.fn.fnamemodify(full_path, ":p:h")
        vim.fn.mkdir(directory, "p")
    end,
})

-- Use aucmd to set formatoptions, otherwise if I put them in options.lua it
-- will get overrule by filetype plugin (super annoying). The other option is to
-- use after/ftplugin but I would have to set formatoptions for every single
-- filetype. According to comment in Ref: In order for this aucmd to work, it has
-- to be defined `after` the default filetype detection (i.e. :filetype plugin
-- on).
-- Ref: https://stackoverflow.com/questions/28375119/how-to-override-options-set-by-ftplugins-in-vim
aucmd({ "Filetype" }, {
    pattern = "*",
    desc = "Set formatoptions",
    group = augroup("SetFormatOptions", { clear = true }),
    callback = function()
        vim.opt.formatoptions = {
            ["1"] = true, -- Don't break a line after a one-letter word.
            ["2"] = false, -- Use indent from 2nd line of a paragraph
            q = true, -- Continue comments with gq"
            c = false, -- Insert current comment leader automatically
            r = true, -- Continue comments when pressing Enter
            o = false, -- Continue comments when pressing 'o' or 'O'
            n = true, -- Recognize numbered lists
            t = false, -- Autowrap lines using text width value
            j = true, -- Remove a comment leader when joining lines.
            l = true, -- When a line longer than 'textwidth', don't format it
        }
    end,
})

-- HLSEARCH
--source: https://github.com/akinsho/dotfiles/blob/main/.config/nvim/plugin/autocommands.lua
--credits: @akinsho
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

vim.keymap.set({ "n", "v", "o", "i", "c" }, "<Plug>(StopHL)", 'execute("nohlsearch")[-1]', { expr = true })

local function stop_hl()
    if vim.v.hlsearch == 0 or vim.api.nvim_get_mode().mode ~= "n" then
        return
    end
    vim.api.nvim_feedkeys(vim.keycode "<Plug>(StopHL)", "m", false)
end

local function hl_search()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local curr_line = vim.api.nvim_get_current_line()
    local ok, match = pcall(vim.fn.matchstrpos, curr_line, vim.fn.getreg "/", 0)
    if not ok then
        return
    end
    local _, p_start, p_end = unpack(match)
    -- if the cursor is in a search result, leave highlighting on
    if col < p_start or col > p_end then
        stop_hl()
    end
end

local inc_search_hl = augroup("IncSearchHighlight", { clear = true })

aucmd("CursorMoved", {
    group = inc_search_hl,
    callback = function() hl_search() end,
})

aucmd("InsertEnter", {
    group = inc_search_hl,
    callback = function() stop_hl() end,
})

aucmd("OptionSet", {
    group = inc_search_hl,
    callback = function()
        vim.schedule(function() vim.cmd "redrawstatus" end)
    end,
})

local aucmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

aucmd({ "TextYankPost" }, {
    pattern = "*",
    desc = "Highlight text on yank",
    group = augroup("TextHighlightYank", { clear = true }),
    callback = function() vim.hl.on_yank { timeout = 200 } end,
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
-- Source: https://github.com/Wansmer/nvim-config/blob/4bbfd1c9c693ae33b8d7a57a9ae9b14a94068bbb/lua/modules/key_listener.lua
-- Source: https://www.reddit.com/r/neovim/comments/zc720y/tip_to_manage_hlsearch/
local auto_hlsearch = vim.api.nvim_create_namespace "auto_hlsearch"

---Deleting hlsearch when it already no needed
local function toggle_hlsearch(char)
    local keys = { "<CR>", "n", "N", "*", "#", "?", "/" }
    local new_hlsearch = vim.tbl_contains(keys, char) and 1 or 0

    if vim.api.nvim_get_vvar "hlsearch" ~= new_hlsearch then
        vim.api.nvim_set_vvar("hlsearch", new_hlsearch)
    end
end

---Handler for pressing keys. Added listeners for modes
---@param char string
local function key_listener(char)
    local key = vim.fn.keytrans(char)
    local mode = vim.fn.mode()
    if mode == "n" then
        toggle_hlsearch(key)
    end
end

vim.on_key(key_listener, auto_hlsearch)

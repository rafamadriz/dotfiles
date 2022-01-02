local M = {}

M.config = function()
    require("which-key").setup {
        plugins = {
            marks = true, -- shows a list of your marks on ' and `
            registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
            -- the presets plugin, adds help for a bunch of default keybindings in Neovim
            -- No actual key bindings are created
            spelling = {
                enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
                suggestions = 20, -- how many suggestions should be shown in the list?
            },
            presets = {
                operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
                motions = true, -- adds help for motions
                text_objects = true, -- help for text objects triggered after entering an operator
                windows = true, -- default bindings on <c-w>
                nav = true, -- misc bindings to work with windows
                z = true, -- bindings for folds, spelling and others prefixed with z
                g = true, -- bindings for prefixed with g
            },
        },
        -- add operators that will trigger motion and text object completion
        -- to enable all native operators, set the preset / operators plugin above
        operators = { gc = "Comments" },
        key_labels = {
            -- override the label used to display some keys. It doesn't effect WK in any other way.
            -- For example:
            ["<space>"] = "SPC",
            ["<cr>"] = "RET",
            ["<tab>"] = "TAB",
        },
        icons = {
            breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
            separator = "➜", -- symbol used between a key and it's label
            group = "+", -- symbol prepended to a group
        },
        window = {
            border = "none", -- none, single, double, shadow
            position = "bottom", -- bottom, top
            margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
            padding = { 1, 1, 1, 1 }, -- extra window padding [top, right, bottom, left]
        },
        layout = {
            height = { min = 3, max = 25 }, -- min and max height of the columns
            width = { min = 10, max = 40 }, -- min and max width of the columns
            spacing = 3, -- spacing between columns
        },
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
        show_help = true, -- show help message on the command line when the popup is visible
        triggers = "auto", -- automatically setup triggers
        -- triggers = {"<leader>"} -- or specifiy a list manually
    }

    -- Normal Mode {{{1
    local mappings = {
        ["<leader>"] = {
            ["<space>"] = "file in project",
            ["/"] = "search in project",
            ["e"] = "explorer",
            h = {
                name = "help",
                h = "help tags",
                m = "man pages",
                o = "options nvim",
                t = "theme",
                p = {
                    name = "plugins",
                    C = "clean",
                    S = "sync",
                    c = "compile",
                    h = "help packer",
                    i = "install",
                    s = "status",
                    u = "update",
                },
            },
            b = {
                name = "buffers",
                ["]"] = "next buffer",
                ["["] = "previous buffer",
                ["%"] = "source file",
                ["<C-t>"] = "focus in new tab",
                Q = "quit all other buffers",
                S = "save all buffers",
                b = "all buffers",
                f = "new file",
                h = "no highlight",
                n = "new buffer",
                q = "quit buffer",
                s = "save buffer",
                v = "new file in split",
            },
            n = {
                name = "notes",
                L = "new link",
                b = "zk backlinks",
                f = "find notes",
                l = "zk links",
                n = "new note",
                o = "zk orphans",
                t = "find tags",
            },
            t = {
                name = "tabs",
                ["["] = "previous tab",
                ["]"] = "next tab",
                f = "file in new tab",
                n = "new tab",
                q = "quit tab",
            },
            w = {
                name = "windows",
                ["+"] = "increase height",
                ["-"] = "decrease height",
                [">"] = "increase width",
                ["<"] = "decrease width",
                ["="] = "normalize split layout",
                T = "break out into new tab",
                h = "jump to left window",
                j = "jump to the down window",
                k = "jump to the up window",
                l = "jump to the right window",
                m = "max out window",
                q = "quit window",
                r = "replace current with next",
                s = "split window",
                v = "vertical split",
                w = "cycle through windows",
            },
            f = {
                name = "find",
                C = "command history",
                R = "registers",
                b = "grep buffer",
                c = "commands",
                f = "file",
                g = "grep project",
                l = "loclist",
                n = "nvim dotfiles",
                q = "quickfix",
                r = "recent files",
                s = "search history",
            },
            g = {
                name = "git",
                ["]"] = "next hunk",
                ["["] = "previous hunk",
                B = "blame line",
                L = "Neogit log",
                R = "reset buffer",
                S = "stage buffer",
                b = "show branches",
                c = "show commits",
                d = "diff show",
                f = "files",
                g = "Neogit",
                l = "blame toggle",
                m = "modified",
                p = "preview hunk",
                r = "reset hunk",
                s = "stage hunk",
                u = "undo last stage hunk",
                y = "copy permalink",
            },
            l = {
                name = "LSP",
                ["'"] = { "<cmd>LspStart<cr>", "LSP start" },
                i = { "<cmd>LspInfo<cr>", "LSP info" },
            },
            q = {
                name = "quit/session",
                Q = "quit all",
                q = "home",
                l = "restore last session",
                c = "restore session in current directory",
            },
            r = {
                name = "run/open",
                ["."] = "find current file",
                J = "append line down",
                K = "append line up",
                b = "open file browser",
                e = "open explorer",
                f = "format",
                g = "gitsigns refresh",
                l = "open loclist window",
                n = "open neovim config",
                q = "open quickfix window",
                r = "repeat last command",
                s = "save without formatting",
                t = "open terminal",
                u = "open undotree",
                c = {
                    name = "colorizer",
                    a = "attach to buffer",
                    t = "toggle",
                },
            },
            z = {
                name = "zen mode",
                a = "ataraxis",
                c = "centered",
                f = "focus",
                m = "minimalist",
                q = "quit zen mode",
            },
        },
        ["g"] = {
            ["p"] = "select last pasted text",
            ["c"] = "comment text",
            ["cc"] = "comment line",
        },
        ["c"] = {
            ["."] = "search & replace word under cursor",
            ["d"] = "cd into current file",
        },
        ["["] = {
            L = "location first",
            Q = "quickfix first",
            l = "location prev",
            q = "quickfix prev",
        },
        ["]"] = {
            L = "location last",
            Q = "quickfix last",
            l = "location next",
            q = "quickfix next",
        },
    }
    -- Visual Mode {{{1
    local visual = {
        ["<leader>"] = {
            ["b"] = { name = "buffers", s = "save buffer" },
            ["f"] = { "format selection" },
            ["g"] = { name = "git link", y = "copy permalink selection" },
        },
    }
    -- }}}

    local wk = require "which-key"
    wk.register(mappings, { mode = "n" })
    wk.register(visual, { mode = "v" })
end

return M
-- vim:foldmethod=marker:foldlevel=0

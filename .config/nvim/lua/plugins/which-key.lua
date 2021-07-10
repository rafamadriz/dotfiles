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

local opts = {
    mode = "n", -- NORMAL mode
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
}

local mappings = {
    ["<leader>"] = {
        ["<space>"] = "file in project",
        ["/"] = "search in project",
        ["e"] = "explorer",
        ["u"] = "undotree",
        h = {
            name = "help",
            h = "help tags",
            m = "man pages",
            o = "options nvim",
            t = "theme",
            p = {
                name = "plugins",
                u = "update",
                i = "install",
                S = "sync",
                c = "compile",
                C = "clean",
                s = "status",
                h = "help packer",
            },
        },
        b = {
            name = "buffers",
            h = "no highlight",
            b = "all buffers",
            s = "save buffer",
            S = "save all buffers",
            q = "quit buffer",
            Q = "quit all other buffers",
            n = "new buffer",
            f = "new file",
            v = "new file in split",
            ["]"] = "next buffer",
            ["["] = "previous buffer",
            ["%"] = "source file",
            ["<C-t>"] = "focus in new tab",
        },
        t = {
            name = "tabs",
            q = "quit tab",
            n = "new tab",
            f = "file in new tab",
            ["["] = "previous tab",
            ["]"] = "next tab",
        },
        w = {
            name = "windows",
            w = "cycle through windows",
            h = "jump to left window",
            j = "jump to the down window",
            k = "jump to the up window",
            l = "jump to the right window",
            q = "quit window",
            s = "split window",
            v = "vertical split",
            m = "max out window",
            T = "break out into new tab",
            r = "replace current with next",
            ["+"] = "increase height",
            ["-"] = "decrease height",
            [">"] = "increase width",
            ["<"] = "decrease width",
            ["="] = "normalize split layout",
        },
        f = {
            name = "find",
            b = "grep buffer",
            C = "command history",
            c = "commands",
            s = "search history",
            f = "file",
            g = "grep project",
            n = "nvim dotfiles",
            r = "recent files",
            R = "registers",
            q = "quickfix",
            l = "loclist",
        },
        g = {
            name = "git",
            ["]"] = "next hunk",
            ["["] = "previous hunk",
            g = "Neogit",
            d = "diff show",
            L = "Neogit log",
            b = "show branches",
            c = "show commits",
            f = "files",
            p = "preview hunk",
            l = "blame toggle",
            B = "blame line",
            r = "reset hunk",
            R = "reset buffer",
            s = "stage hunk",
            S = "stage buffer",
            u = "undo last stage hunk",
            y = "copy permalink",
        },
        l = {
            name = "LSP",
            i = { "<cmd>LspInfo<cr>", "LSP info" },
            ["'"] = { "<cmd>LspStart<cr>", "LSP start" },
        },
        s = {
            name = "session",
            s = "session save",
            q = "session quit",
            d = "session delete",
            l = "session load",
            r = "session reload",
        },
        r = {
            name = "run/open",
            ["|"] = "toggle color column",
            ["'"] = "Home",
            r = "repeat last command",
            i = "indent guides toggle",
            t = "open terminal",
            g = "gitsigns refresh",
            b = "open file browser",
            f = "find current file",
            e = "open explorer",
            u = "open undotree",
            n = "open neovim config",
            K = "append line up",
            J = "append line down",
            q = "open quickfix window",
            l = "open loclist window",
            c = {
                name = "colorizer",
                a = "attach to buffer",
                t = "toggle",
            },
        },
        z = {
            name = "zen mode",
            f = "focus",
            c = "centered",
            m = "minimalist",
            a = "ataraxis",
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
        l = "location prev",
        L = "location first",
        q = "quickfix prev",
        Q = "quickfix first",
    },
    ["]"] = {
        l = "location next",
        L = "location last",
        q = "quickfix next",
        Q = "quickfix last",
    },
}

local wk = require "which-key"
wk.register(mappings, opts)

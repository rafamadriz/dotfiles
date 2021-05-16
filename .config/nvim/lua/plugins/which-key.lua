require("which-key").setup {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20 -- how many suggestions should be shown in the list?
        },
        presets = {
            operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true -- bindings for prefixed with g
        }
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    operators = {gc = "Comments"},
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+" -- symbol prepended to a group
    },
    window = {
        border = "none", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = {1, 0, 1, 0}, -- extra window margin [top, right, bottom, left]
        padding = {1, 1, 1, 1} -- extra window padding [top, right, bottom, left]
    },
    layout = {
        height = {min = 4, max = 25}, -- min and max height of the columns
        width = {min = 20, max = 50}, -- min and max width of the columns
        spacing = 5 -- spacing between columns
    },
    hidden = {"<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    triggers = "auto" -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specifiy a list manually
}

local opts = {
    mode = "n", -- NORMAL mode
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false -- use `nowait` when creating keymaps
}

local mappings = {
    ["<leader>"] = {
        ["."] = {"<cmd>Telescope find_files<cr>", "find file in project"},
        ["/"] = {"<cmd>Telescope live_grep<cr>", "search project"},
        ["e"] = "explorer",
        ["u"] = "undotree",
        b = {
            name = "buffers",
            h = "no highlight",
            b = "all buffers",
            s = "save buffer",
            S = "save all buffers",
            q = "quit buffer",
            Q = "quit all buffers but current",
            ["]"] = "next buffer",
            ["["] = "previous buffer",
            u = "source file"
        },
        w = {
            name = "windows",
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
            ["="] = "equally high and width"
        },
        f = {
            name = "find",
            b = "buffer fuzzy finder",
            c = "command history",
            s = "search history",
            t = "theme",
            f = "file",
            g = "grep text",
            v = "vim tags",
            n = "nvim dotfiles",
            r = "recent files"
        },
        n = {
            name = "new",
            f = "new file",
            s = "new file in a split",
            t = "new file in tab"
        },
        g = {
            name = "git",
            ["]"] = "next hunk",
            ["["] = "previous hunk",
            b = "branches",
            c = "commits",
            f = "files",
            s = "status",
            p = "preview hunk",
            l = "line blame",
            r = "reset hunk",
            R = "reset buffer",
            I = "reset buffer index",
            t = "stage hunk",
            T = "stage buffer",
            u = "undo last stage hunk"
        },
        l = {
            name = "LSP",
            a = {"code action"},
            A = {"range code action"},
            d = {"document diagnostics"},
            D = {"workspace diagnostics"},
            l = {"line diagnostics"},
            i = {"LSP info"},
            h = {"<cmd>lua vim.lsp.buf.hover()<cr>", "hover document"},
            F = {"<cmd>lua vim.lsp.buf.formatting()<cr>", "format"},
            r = {"rename"},
            s = {"document symbols"},
            S = {"workspace symbols"},
            ["'"] = "LSP start",
            ["'t"] = {"<cmd>LspStart TsServer<cr>", "javascript, typescript"},
            ["'e"] = {"<cmd>LspStart emmet_ls<cr>", "emmet"},
            ["'b"] = {"<cmd>LspStart bashls<cr>", "bash"},
            ["'l"] = {"<cmd>LspStart sumneko_lua<cr>", "lua"},
            ["'c"] = {"<cmd>LspStart clangd<cr>", "C/C++"},
            ["'j"] = {"<cmd>LspStart jsonls<cr>", "json"},
            ["'p"] = {"<cmd>LspStart pyright<cr>", "python"},
            ["'L"] = {"<cmd>LspStart texlab<cr>", "latex"},
            ["'h"] = {"<cmd>LspStart html<cr>", "HTML"},
            ["'C"] = {"<cmd>LspStart cssls<cr>", "CSS"},
            ["."] = {"LSP stop"},
            [".a"] = {"<cmd>LspStop<cr>", "stop all"},
            [".s"] = {"select"}
        },
        T = {
            name = "tabs",
            ["]"] = {"<cmd>tabnext<cr>", "next"},
            ["["] = {"<cmd>tabprevious<cr>", "previous"},
            q = {"<cmd>tabclose<cr>", "quit tab"}
        },
        s = {
            name = "session",
            s = {"<cmd>SSave<cr>", "session save"},
            c = {"<cmd>SClose<cr>", "session close"},
            d = {"<cmd>SDelete<cr>", "session delete"},
            l = {"<cmd>SLoad<cr>", "session load"}
        },
        o = {
            name = "open",
            t = {"<cmd>ToggleTerm<cr>", "terminal"},
            f = {"<cmd>NvimTreeFindFile<cr>", "find current file"},
            e = {"<cmd>NvimTreetoggle<cr>", "explorer"},
            u = {"<cmd>UndotreeToggle<cr>", "undotree"}
        },
        p = {
            name = "plugins",
            u = {"<cmd>PackerUpdate<cr>", "update"},
            i = {"<cmd>PackerInstall<cr>", "install"},
            S = {"<cmd>PackerSync<cr>", "sync"},
            c = {"<cmd>PackerClean<cr>", "clean"},
            s = {"<cmd>PackerStatus<cr>", "status"}
        }
    },
    ["g"] = {
        ["d"] = "LSP definition",
        ["D"] = "LSP declaration",
        ["K"] = "LSP signature help",
        ["r"] = "LSP declaration",
        ["y"] = "LSP type definition",
        ["h"] = "LSP doc",
        ["c"] = "comment text",
        ["cc"] = "comment line"
    },
    ["s"] = {
        a = "add surrounding",
        d = "delete surrounding",
        db = "automatically seearch and delete",
        r = "replace surrounding",
        rb = "automatically search and select to replace"
    }
}

local wk = require("which-key")
wk.register(mappings, opts)

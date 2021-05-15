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
        ["!"] = "close all buffers but current",
        ["*"] = "save all buffers",
        ["b"] = "show buffers",
        ["q"] = "quit buffer",
        ["w"] = "save",
        ["e"] = "explorer",
        ["u"] = "undotree",
        ["h"] = "no highlight",
        ["["] = {"<cmd>bprev<cr>", "prev buffer"},
        ["]"] = {"<cmd>bnext<cr>", "next buffer"},
        f = {
            name = "find",
            c = {"<cmd>Telescope colorscheme<cr>", "colorscheme"},
            f = {"<cmd>Telescope find_files<cr>", "file"},
            g = {"<cmd>Telescope live_grep<cr>", "grep text"},
            h = {"<cmd>Telescope help_tags<cr>", "vim tags"},
            n = {"<cmd>lua require('utils.core').search_nvim()<cr>", "nvim dotfiles"},
            o = {"<cmd>Telescope oldfiles<cr>", "recent files"},
            p = "personal config",
            pc = {"<cmd>e ~/.config/nvim/lua/config.lua<cr>", "config"},
            pi = {"<cmd>e ~/.config/nvim/lua/init.lua<cr>", "init"},
            pp = {"<cmd>e ~/.config/nvim/lua/plugins.lua<cr>", "plugins"},
            ps = {"split"},
            psc = {"<cmd>vsp ~/.config/nvim/lua/config.lua<cr>", "split config"},
            psi = {"<cmd>vsp ~/.config/nvim/lua/init.lua<cr>", "split init"},
            psp = {"<cmd>vsp ~/.config/nvim/lua/plugins.lua<cr>", "split plugins"}
        },
        n = {
            name = "new",
            f = "create new file",
            s = "create new file in a split",
            t = "create new file in tab"
        },
        g = {
            name = "git",
            f = {"<cmd>Telescope git_files<cr>", "files"},
            c = {"<cmd>Telescope git_commits<cr>", "commits"},
            b = {"<cmd>Telescope git_branches<cr>", "branches"},
            s = {"<cmd>Telescope git_status<cr>", "status"},
            n = {"<cmd>Gitsigns next_hunk<cr>", "next hunk"},
            p = {"<cmd>Gitsigns prev_hunk<cr>", "prev hunk"},
            v = {"<cmd>Gitsigns preview_hunk<cr>", "preview hunk"},
            r = {"<cmd>Gitsigns reset_hunk<cr>", "reset hunk"},
            R = {"<cmd>Gitsigns reset_buffer<cr>", "reset buffer"}
        },
        l = {
            name = "LSP",
            a = {"<cmd>Lspsaga code_action<cr>", "code action"},
            A = {"<cmd>Lspsaga range_code_action<cr>", "selected action"},
            d = {"<cmd>Telescope lsp_document_diagnostics<cr>", "document diagnostics"},
            D = {"<cmd>Telescope lsp_workspace_diagnostics<cr>", "workspace diagnostics"},
            l = {"<cmd>Lspsaga show_line_diagnostics<cr>", "line diagnostics"},
            f = {"<cmd>Lspsaga lsp_finder<cr>", "LSP finder"},
            i = {"<cmd>LspInfo<cr>", "LSP info"},
            k = {"<cmd>Lspsaga signature_help<cr>", "LSP signature help"},
            h = {"<cmd>Lspsaga hover_doc<cr>", "hover document"},
            F = {"<cmd>lua vim.lsp.buf.formatting()<cr>", "format"},
            p = {"<cmd>Lspsaga preview_definition<cr>", "preview definition"},
            r = {"<cmd>Lspsaga rename<cr>", "rename"},
            s = {"<cmd>Telescope lsp_document_symbols<cr>", "document symbols"},
            S = {"<cmd>Telescope lsp_workspace_symbols<cr>", "workspace symbols"},
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
        j = {
            name = "jump windows",
            h = {"<cmd>wincmd h<cr>", "Left"},
            j = {"<cmd>wincmd j<cr>", "Down"},
            k = {"<cmd>wincmd k<cr>", "Up"},
            l = {"<cmd>wincmd l<cr>", "Right"}
        },
        T = {
            name = "tabs",
            n = {"<cmd>tabnext<cr>", "next"},
            p = {"<cmd>tabprevious<cr>", "previous"},
            q = {"<cmd>tabclose<cr>", "quit tab"}
        },
        t = {
            name = "text",
            [","] = "add comma to end of line",
            [";"] = "add semicolon to end of line",
            [":"] = "add colon to end of line",
            u = "lowercase",
            U = "uppercase",
            S = "source file"
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
            e = {"<cmd>NvimTreeFindFile<cr>", "find current file"}
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

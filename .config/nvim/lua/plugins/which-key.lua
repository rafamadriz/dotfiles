require("which-key").setup {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
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
        ["b"] = "Show Buffers",
        ["q"] = "Quit Buffer",
        ["w"] = "Save",
        ["W"] = "Save All",
        ["e"] = "Explorer",
        ["u"] = "UndoTree",
        ["h"] = "No Highlight",
        ["x"] = "Shellcheck",
        ["["] = {"<cmd>bprev<cr>", "Prev Buffer"},
        ["]"] = {"<cmd>bnext<cr>", "Next Buffer"},
        f = {
            name = "find",
            c = {"<cmd>Telescope colorscheme<cr>", "Colorscheme"},
            f = {"<cmd>Telescope find_files<cr>", "File"},
            g = {"<cmd>Telescope live_grep<cr>", "Text"},
            h = {"<cmd>Telescope help_tags<cr>", "Vim Tags"},
            n = {"<cmd>lua require('utils.core').search_nvim()<cr>", "Nvim dotfiles"},
            o = {"<cmd>Telescope oldfiles<cr>", "Recent Files"}
        },
        g = {
            name = "git",
            f = {"<cmd>Telescope git_files<cr>", "Files"},
            c = {"<cmd>Telescope git_commits<cr>", "Commits"},
            b = {"<cmd>Telescope git_branches<cr>", "Branches"},
            s = {"<cmd>Telescope git_status<cr>", "Status"},
            n = {"<cmd>Gitsigns next_hunk<cr>", "Next Hunk"},
            p = {"<cmd>Gitsigns prev_hunk<cr>", "Prev Hunk"},
            v = {"<cmd>Gitsigns preview_hunk<cr>", "Preview Hunk"},
            r = {"<cmd>Gitsigns reset_hunk<cr>", "Reset Hunk"},
            R = {"<cmd>Gitsigns reset_buffer<cr>", "Reset Buffer"}
        },
        l = {
            name = "LSP",
            a = {"<cmd>Lspsaga code_action<cr>", "Code Action"},
            A = {"<cmd>Lspsaga range_code_action<cr>", "Selected Action"},
            d = {"<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics"},
            D = {"<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics"},
            l = {"<cmd>Lspsaga show_line_diagnostics<cr>", "Line Diagnostics"},
            f = {"<cmd>Lspsaga lsp_finder<cr>", "LSP Finder"},
            i = {"<cmd>LspInfo<cr>", "LSP Info"},
            k = {"<cmd>Lspsaga signature_help<cr>", "LSP Signature Help"},
            h = {"<cmd>Lspsaga hover_doc<cr>", "Hover Document"},
            F = {"<cmd>lua vim.lsp.buf.formatting()<cr>", "Format"},
            p = {"<cmd>Lspsaga preview_definition<cr>", "Preview Definition"},
            r = {"<cmd>Lspsaga rename<cr>", "Rename"},
            s = {"<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols"},
            S = {"<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols"},
            ["'"] = "LSP Start",
            ["'t"] = {"<cmd>LspStart TsServer<cr>", "Javascript, Typescript"},
            ["'e"] = {"<cmd>LspStart emmet_ls<cr>", "Emmet"},
            ["'b"] = {"<cmd>LspStart bashls<cr>", "Bash"},
            ["'l"] = {"<cmd>LspStart sumneko_lua<cr>", "Lua"},
            ["'c"] = {"<cmd>LspStart clangd<cr>", "C/C++"},
            ["'j"] = {"<cmd>LspStart jsonls<cr>", "Json"},
            ["'p"] = {"<cmd>LspStart pyright<cr>", "Python"},
            ["'L"] = {"<cmd>LspStart texlab<cr>", "Latex"},
            ["'h"] = {"<cmd>LspStart html<cr>", "HTML"},
            ["'C"] = {"<cmd>LspStart cssls<cr>", "CSS"},
            ["."] = {"<cmd>LspStop<cr>", "LSP Stop All"}
        },
        j = {
            name = "Jump Windows",
            h = {"<cmd>wincmd h<cr>", "Left"},
            j = {"<cmd>wincmd j<cr>", "Down"},
            k = {"<cmd>wincmd k<cr>", "Up"},
            l = {"<cmd>wincmd l<cr>", "Right"}
        },
        t = {
            name = "Tabs",
            n = {"<cmd>tabnext<cr>", "Next"},
            p = {"<cmd>tabprevious<cr>", "Previous"},
            q = {"<cmd>tabclose<cr>", "Quit Tab"}
        },
        s = {
            name = "Session",
            s = {"<cmd>SSave<cr>", "Session Save"},
            c = {"<cmd>SClose<cr>", "Session Close"},
            d = {"<cmd>SDelete<cr>", "Session Delete"},
            l = {"<cmd>SLoad<cr>", "Session Load"}
        },
        o = {
            name = "Open",
            m = "Markdown",
            mp = {"<cmd>MarkdownPreviewToggle<cr>", "Preview"},
            ms = {"<cmd>MarkdownPreviewStop<cr>", "Preview Stop"},
            t = {"<cmd>ToggleTerm<cr>", "Terminal"},
            e = {"<cmd>NvimTreeFindFile<cr>", "Find Current File"},
            b = "Bracey Server",
            bb = {"<cmd>Bracey<cr>", "Start"},
            bs = {"<cmd>BraceyStop<cr>", "Stop"},
            br = {"<cmd>BraceyReload<cr>", "Reload"}
        },
        p = {
            name = "Plugins",
            u = {"<cmd>PackerUpdate<cr>", "Update"},
            i = {"<cmd>PackerInstall<cr>", "Install"},
            S = {"<cmd>PackerSync<cr>", "Sync"},
            c = {"<cmd>PackerClean<cr>", "Clean"},
            s = {"<cmd>PackerStatus<cr>", "Status"}
        }
    },
    ["g"] = {
        ["V"] = "Visually select last edited/pasted text",
        ["d"] = "LSP definition",
        ["D"] = "LSP declaration",
        ["r"] = "LSP declaration",
        ["y"] = "LSP type definition",
        ["h"] = "LSP doc",
        ["c"] = "Comment text"
    }
}

local wk = require("which-key")
wk.register(mappings, opts)

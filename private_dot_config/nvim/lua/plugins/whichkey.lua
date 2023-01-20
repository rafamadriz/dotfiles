local wk = require "which-key"

wk.setup {
    plugins = {
        spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
        },
    },
    -- add operators that will trigger motion and text object completion
    operators = { gc = "Comments", gb = "Comments" },
    key_labels = {
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
    },
}

local mappings = {
    ["<leader>"] = {
        L = {
            name = "Lazy",
            s = { "<cmd>Lazy<CR>", "Lazy show" },
            S = { "<cmd>Lazy sync<CR>", "Lazy sync" },
            i = { "<cmd>Lazy install<CR>", "Lazy install" },
            c = { "<cmd>Lazy clean<CR>", "Lazy clean" },
            u = { "<cmd>Lazy update<CR>", "Lazy update" },
            l = { "<cmd>Lazy log<CR>", "Lazy log" },
        },
        q = {
            name = "Quit/Session",
            Q = { "<cmd>quitall<CR>", "Quit all" },
            p = { "<cmd>Telescope projects<CR>", "Projects" },
            s = {
                name = "Session management",
                s = { "<cmd>SessionManager save_current_session<CR>", "Save session" },
                r = { "<cmd>SessionManager load_session<CR>", "Select session" },
                l = { "<cmd>SessionManager load_last_session<CR>", "Last session" },
                c = {
                    "<cmd>SessionManager load_current_dir_session<CR>",
                    "Load current dir session",
                },
            },
        },
    },
    ["["] = {
        name = "Previous",
    },
    ["]"] = {
        name = "Next",
    },
    ["g"] = {
        ["b"] = "Comment block",
        ["c"] = "Comment text",
    },
}

wk.register(mappings, { mode = "n" })
wk.register({ ["<leader>b"] = { name = "Buffer" } }, { mode = "v" })

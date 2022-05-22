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
        p = {
            name = "Packer",
            s = { "<cmd>PackerStatus<CR>", "Packer status" },
            S = { "<cmd>PackerSync<CR>", "Packer sync" },
            i = { "<cmd>PackerInstall<CR>", "Packer install" },
            C = { "<cmd>PackerClean<CR>", "Packer clean" },
            c = { "<cmd>PackerCompile<CR>", "Packer compile" },
        },
        q = {
            name = "Quit/Session",
            Q = { "<cmd>quitall<CR>", "Quit all" },
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
        ["bc"] = "Comment block line",
        ["c"] = "Comment text",
        ["cc"] = "Comment line",
    },
    ["s"] = {
        ["a"] = "Surroud add",
        ["r"] = "Surroud replace",
        ["d"] = "Surroud delete",
    },
}

wk.register(mappings, { mode = "n" })
wk.register({ ["<leader>b"] = { name = "Buffer" } }, { mode = "v" })

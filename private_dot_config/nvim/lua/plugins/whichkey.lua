local wk = require("which-key")

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
}

wk.register(mappings, { mode = 'n' })
wk.register({ ["<leader>b"] = { name = "Buffer", } }, { mode = 'v' })
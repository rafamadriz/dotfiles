return {
    "folke/which-key.nvim",
    lazy = false,
    config = function()
        local wk = require "which-key"

        wk.setup {
            operators = { gc = "Comments", gb = "Comments", ys = "Surround" },
            key_labels = {
                ["<space>"] = "SPC",
                ["<cr>"] = "RET",
                ["<tab>"] = "TAB",
            },
        }

        local n_mappings = {
            ["<leader>"] = {
                ["f"] = { name = "Find" },
                ["b"] = { name = "Buffer" },
                ["g"] = { name = "Git" },
                ["l"] = { name = "LSP" },
            },
        }
        wk.register(n_mappings, { mode = "n" })
    end,
}

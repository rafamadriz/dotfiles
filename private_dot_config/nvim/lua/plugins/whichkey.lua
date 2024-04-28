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

        local mappings = {
            ["<leader>"] = {
                ["f"] = { name = "Find" },
                ["b"] = { name = "Buffer" },
                ["g"] = { name = "Git" },
                ["l"] = { name = "LSP" },
                ["a"] = "which_key_ignore",
                ["1"] = "which_key_ignore",
                ["2"] = "which_key_ignore",
                ["3"] = "which_key_ignore",
                ["4"] = "which_key_ignore",
            },
        }
        wk.register(mappings, { mode = "n" })
        wk.register(mappings, { mode = "v" })
    end,
}

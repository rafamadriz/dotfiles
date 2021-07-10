-- Set indent width to two spaces
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2

local mappings = {
    ["<leader>"] = {
        r = {
            l = "live server",
            ll = { "<cmd>Bracey<cr>", "live start" },
            ls = { "<cmd>BraceyStop<cr>", "stop" },
            lr = { "<cmd>BraceyReload<cr>", "reload" },
        },
    },
}

local wk = require "which-key"
wk.register(mappings, opts)

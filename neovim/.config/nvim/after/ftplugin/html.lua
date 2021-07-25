-- Set indent width to two spaces
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2

local mappings = {
    ["<leader>"] = {
        r = {
            L = { name = "live server" },
            Ll = { "<cmd>Bracey<cr>", "live start" },
            Ls = { "<cmd>BraceyStop<cr>", "stop" },
            Lr = { "<cmd>BraceyReload<cr>", "reload" },
        },
    },
}
vim.cmd "packadd which-key.nvim"
local wk = require "which-key"
wk.register(mappings, opts)

local mappings = {
    ["<leader>"] = {
        r = {
            m = { name = "markdown" },
            mp = { "<cmd>MarkdownPreviewToggle<cr>", "preview" },
            ms = { "<cmd>MarkdownPreviewStop<cr>", "preview stop" },
        },
    },
}

vim.cmd "packadd which-key.nvim"
local wk = require "which-key"
wk.register(mappings, opts)

vim.opt_local.relativenumber = false
vim.opt_local.wrap = true
vim.opt_local.spell = true

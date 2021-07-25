local mappings = {
    ["<leader>"] = {
        ["x"] = { ":!clear && shellcheck -x %<CR>", "shellcheck" },
    },
}
vim.cmd "packadd which-key.nvim"
local wk = require "which-key"
wk.register(mappings, opts)

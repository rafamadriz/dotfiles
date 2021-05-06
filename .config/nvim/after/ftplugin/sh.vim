lua << EOF
local opts = {
    mode = "n", -- NORMAL mode
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false -- use `nowait` when creating keymaps
}

local mappings = {
    ["<leader>"] = {
        ["x"] = {":!clear && shellcheck -x %<CR>","shellcheck"},
  }
}

local wk = require("which-key")
wk.register(mappings, opts)
EOF

lua << EOF
local mappings = {
    ["<leader>"] = {
        ["x"] = {":!clear && shellcheck -x %<CR>","shellcheck"},
  }
}

local wk = require("which-key")
wk.register(mappings, opts)
EOF

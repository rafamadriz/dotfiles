" Set indent width to two spaces
setlocal ts=2 sw=2 sts=2

" Fix quirkiness in indentation
setlocal indentkeys-=*<Return>

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
        o = {
            name = "Open",
            b = "Bracey Server",
            bb = {"<cmd>Bracey<cr>", "start"},
            bs = {"<cmd>BraceyStop<cr>", "stop"},
            br = {"<cmd>BraceyReload<cr>", "reload"}
        }
    }
}

local wk = require("which-key")
wk.register(mappings, opts)
EOF

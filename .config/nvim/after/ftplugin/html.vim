" Set indent width to two spaces
setlocal ts=2 sw=2 sts=2

" Fix quirkiness in indentation
setlocal indentkeys-=*<Return>

lua << EOF
local mappings = {
    ["<leader>"] = {
        o = {
            l = "live server",
            ll = {"<cmd>Bracey<cr>", "live start"},
            ls = {"<cmd>BraceyStop<cr>", "stop"},
            lr = {"<cmd>BraceyReload<cr>", "reload"}
        }
    }
}

local wk = require("which-key")
wk.register(mappings, opts)
EOF

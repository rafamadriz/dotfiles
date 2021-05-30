lua << EOF
local mappings = {
    ["<leader>"] = {
        o = {
            m = "markdown",
            mp = {"<cmd>MarkdownPreviewToggle<cr>", "preview"},
            ms = {"<cmd>MarkdownPreviewStop<cr>", "preview stop"},
        }
    }
}

local wk = require("which-key")
wk.register(mappings, opts)
EOF

set norelativenumber

local u = require("utils")

-- TODO figure out why this don't work
vim.fn.sign_define(
    "LspDiagnosticsSignError",
    {
        texthl = "LspDiagnosticsSignError",
        text = "",
        numhl = "LspDiagnosticsSignError"
    }
)
vim.fn.sign_define(
    "LspDiagnosticsSignWarning",
    {
        texthl = "LspDiagnosticsSignWarning",
        text = "",
        numhl = "LspDiagnosticsSignWarning"
    }
)
vim.fn.sign_define(
    "LspDiagnosticsSignInformation",
    {
        texthl = "LspDiagnosticsSignInformation",
        text = "",
        numhl = "LspDiagnosticsSignInformation"
    }
)
vim.fn.sign_define(
    "LspDiagnosticsSignHint",
    {
        texthl = "LspDiagnosticsSignHint",
        text = "",
        numhl = "LspDiagnosticsSignHint"
    }
)

require "compe".setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = "enable",
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,
    source = {
        path = {kind = "  "},
        buffer = {kind = "  "},
        calc = {kind = "  "},
        vsnip = {kind = "  "},
        nvim_lsp = {kind = "  "},
        nvim_lua = {kind = "  "},
        spell = {kind = "  "},
        tags = false,
        snippets_nvim = {kind = "  "},
        treesitter = {kind = "  "},
        emoji = {kind = " ﲃ "}
        -- for emoji press : (idk if that in compe tho)
    }
}

-- symbols for autocomplete
require("lspkind").init(
    {
        with_text = false,
        symbol_map = {
            Text = "  ",
            Method = "  ",
            Function = " ƒ ",
            Constructor = "  ",
            Variable = "[]",
            Class = "  ",
            Interface = " 蘒",
            Module = "  ",
            Property = "  ",
            Unit = " 塞 ",
            Value = "  ",
            Enum = " 練",
            Keyword = "  ",
            Snippet = "  ",
            Color = "",
            File = "",
            Folder = " ﱮ ",
            EnumMember = "  ",
            Constant = "  ",
            Struct = "  "
        }
    }
)

u.map("i", "<Tab>", [[ pumvisible() ? "\<C-n>" : "\<Tab>" ]], {expr = true})
u.map("i", "<S-Tab>", [[ pumvisible() ? "\<C-p>" : "\<S-Tab>" ]], {expr = true})

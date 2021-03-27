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
        vsnip = {kind = ""},
        nvim_lsp = {kind = ""},
        nvim_lua = {kind = " "},
        spell = {kind = "  "},
        tags = true,
        -- treesitter = true,
        emoji = {kind = " ﲃ "}
    }
}

-- symbols for autocomplete
require("lspkind").init(
    {
        with_text = true,
        symbol_map = {
            Text = "",
            Method = "ƒ",
            Function = "",
            Constructor = "",
            Variable = "",
            Class = "",
            Interface = "ﰮ",
            Module = "",
            Property = "",
            Unit = "",
            Value = "",
            Enum = "了",
            Keyword = "",
            Snippet = "﬌",
            Color = "",
            File = "",
            Folder = "",
            EnumMember = "",
            Constant = "",
            Struct = ""
        }
    }
)

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col(".") - 1
    if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    elseif vim.fn.call("vsnip#available", {1}) == 1 then
        return t "<Plug>(vsnip-expand-or-jump)"
    elseif check_back_space() then
        return t "<Tab>"
    else
        return vim.fn["compe#complete"]()
    end
end
_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
    elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
        return t "<Plug>(vsnip-jump-prev)"
    else
        return t "<S-Tab>"
    end
end

u.map("i", "<CR>", "compe#confirm('<CR>')", {expr = true})
vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

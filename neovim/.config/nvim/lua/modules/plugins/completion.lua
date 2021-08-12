local M = {}
local map = vim.api.nvim_set_keymap

local with_text = function(text, icon)
    if as._default(vim.g.code_compe_item_with_text) then
        return text
    else
        return icon
    end
end

M.compe = function()
    require("compe").setup {
        enabled = true,
        autocomplete = as._default(vim.g.code_compe_autocomplete),
        debug = false,
        min_length = 3,
        preselect = "always",
        throttle_time = 80,
        source_timeout = 200,
        incomplete_delay = 400,
        max_abbr_width = 100,
        max_kind_width = 100,
        max_menu_width = 100,
        documentation = {
            border = as._lsp_borders(vim.g.code_compe_doc_window_border), -- the border option is the same as `|help nvim_open_win|`
            max_width = 60,
            min_width = 60,
        },
        source = {
            path = {
                menu = "[P]",
                kind = with_text("  Path", ""),
            },
            buffer = {
                menu = "[B]",
                kind = with_text("   Buffer", " "),
            },
            calc = {
                menu = "[C]",
                kind = with_text("   Calc", ""),
            },
            vsnip = {
                menu = "[S]",
                priority = 1500,
                kind = with_text("   Snippet", " "),
            },
            spell = {
                menu = "[E]",
                kind = with_text("   Spell", ""),
            },
            emoji = {
                menu = "[ ﲃ ]",
                filetypes = { "markdown", "text" },
            },
            nvim_lsp = { menu = "[L]" },
            nvim_lua = { menu = "[]" },
        },
    }

    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    local check_back_space = function()
        local col = vim.fn.col "." - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match "%s" ~= nil
    end

    -- Use (s-)tab to:
    --- move to prev/next item in completion menuone
    --- jump to prev/next snippet's placeholder
    _G.tab_complete = function()
        if vim.fn.pumvisible() == 1 then
            return t "<C-n>"
        elseif vim.fn.call("vsnip#available", { 1 }) == 1 then
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
        elseif vim.fn.call("vsnip#jumpable", { -1 }) == 1 then
            return t "<Plug>(vsnip-jump-prev)"
        else
            return t "<S-Tab>"
        end
    end
    map("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
    map("s", "<Tab>", "v:lua.tab_complete()", { expr = true })
    map("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
    map("s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
    map("i", "<C-e>", "compe#close('<C-e>')", { expr = true })
    map("i", "<C-Space>", "compe#complete()", { expr = true })
    map("i", "<C-d>", "compe#scroll({ 'delta': +4 })", { expr = true })
    map("i", "<C-f>", "compe#scroll({ 'delta': -4 })", { expr = true })
    map("i", "<C-l>", [[vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<C-l>']], { expr = true })
    map("s", "<C-l>", [[vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<C-l>']], { expr = true })
end

M.autopairs = function()
    if as._default(vim.g.code_compe_autopairs) then
        require("nvim-autopairs").setup {
            disable_filetype = { "TelescopePrompt", "vim" },
            check_ts = true,
            fast_wrap = {},
        }
        require("nvim-autopairs.completion.compe").setup {
            map_cr = true, --  map <CR> on insert mode
            map_complete = true, -- it will auto insert `(` after select function or method item
        }
    end
end

return M

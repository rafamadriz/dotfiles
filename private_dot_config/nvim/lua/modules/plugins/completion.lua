local M = {}

-- symbols for autocomplete
local lsp_symbols = {
    Class = "   Class",
    Color = "   Color",
    Constant = "   Constant",
    Constructor = "   Constructor",
    Enum = " ❐  Enum",
    EnumMember = "   EnumMember",
    Event = "   Event",
    Field = " ﴲ  Field",
    File = "   File",
    Folder = "   Folder",
    Function = "   Function",
    Interface = " ﰮ  Interface",
    Keyword = "   Keyword",
    Method = "   Method",
    Module = "   Module",
    Operator = "   Operator",
    Property = "   Property",
    Reference = "   Reference",
    Snippet = " ﬌  Snippet",
    Struct = " ﳤ  Struct",
    Text = "   Text",
    TypeParameter = "   TypeParameter",
    Unit = "   Unit",
    Value = "   Value",
    Variable = "[] Variable",
}

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0
        and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s"
            == nil
end

M.setup = function()
    local cmp = require "cmp"

    -- require("cmp_nvim_lsp").setup()

    if not as._default(vim.g.code_autocomplete) then
        cmp.setup { completion = { autocomplete = false } }
    end

    cmp.setup {
        completion = {
            completeopt = "menu,menuone,noinsert",
            -- keyword_length = 3,
        },
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        mapping = {
            ["<Tab>"] = cmp.mapping(function(fallback)
                local luasnip = require "luasnip"
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, {
                "i",
                "s",
            }),
            ["<S-Tab>"] = cmp.mapping(function()
                local luasnip = require "luasnip"
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, {
                "i",
                "s",
            }),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<CR>"] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            },
        },
        formatting = {
            format = function(entry, item)
                item.kind = lsp_symbols[item.kind]
                item.menu = ({
                    nvim_lsp = "[L]",
                    path = "[P]",
                    calc = "[C]",
                    luasnip = "[S]",
                    buffer = "[B]",
                    spell = "[Spell]",
                })[entry.source.name]
                return item
            end,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        sources = {
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
            { name = "nvim_lua" },
            { name = "spell" },
        },
    }

    local map = vim.api.nvim_set_keymap
    map("i", "<C-j>", "<Plug>luasnip-expand-or-jump", { silent = true })
    map("i", "<C-k>", "<cmd>lua require('luasnip').jump(-1)<Cr>", { silent = true })
end

M.autopairs = function()
    if as._default(vim.g.code_autopairs) then
        local pairs = require "nvim-autopairs"
        local Rule = require "nvim-autopairs.rule"
        local endwise = require("nvim-autopairs.ts-rule").endwise

        pairs.setup {
            check_ts = false,
            disable_in_macro = true,
        }

        -- Custom rules
        pairs.add_rules {
            -- arrow key on javascript, typescript
            Rule(
                "%(.*%)%s*%=>$",
                " {}",
                { "typescript", "typescriptreact", "javascript", "javascriptreact" }
            ):use_regex(true):set_end_pair_length(1),
            -- endwise
            endwise("then$", "end", "lua", "if_statement"),
            endwise("function%(.*%)$", "end", "lua", nil),
        }
    end
end

return M

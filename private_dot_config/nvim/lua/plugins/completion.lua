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

return {
    {
        "hrsh7th/nvim-cmp",
        keys = { ":" },
        event = "InsertEnter",
        dependencies = {
            { "petertriho/cmp-git", config = true },
            { "lukas-reineke/cmp-rg" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-nvim-lua" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-cmdline" },
        },
        config = function()
            local cmp = require "cmp"
            cmp.setup {
                snippet = {
                    expand = function(args) require("luasnip").lsp_expand(args.body) end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = {
                    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
                    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
                    ["<Down>"] = cmp.mapping.select_next_item {
                        behavior = cmp.SelectBehavior.Insert,
                    },
                    ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    },
                },
                formatting = {
                    format = function(entry, item)
                        item.kind = lsp_symbols[item.kind]
                        item.menu = ({
                            nvim_lsp = "[LSP]",
                            path = "[F]",
                            luasnip = "[S]",
                            buffer = "[B]",
                            nvim_lua = "[Lua]",
                            git = "[Git]",
                            rg = "[RG]",
                        })[entry.source.name]
                        return item
                    end,
                },
                sources = cmp.config.sources {
                    { name = "nvim_lsp", priority = 20, max_item_count = 15 },
                    { name = "luasnip", priority = 15 },
                    {
                        name = "rg",
                        option = {
                            additional_arguments = "--hidden --smart-case --glob '!.git/'",
                            context_before = 5,
                            context_after = 5,
                        },
                        keyword_length = 3,
                        max_item_count = 5,
                        priority = 2,
                    },
                    {
                        name = "buffer",
                        keyword_length = 3,
                        max_item_count = 5,
                        priority = -2,
                        option = {
                            get_bufnrs = function() return vim.api.nvim_list_bufs() end,
                            keyword_pattern = [[\k\+]],
                        },
                    },
                    { name = "path" },
                    { name = "nvim_lua" },
                },
                experimental = {
                    ghost_text = true,
                },
            }
            cmp.setup.filetype("gitcommit", {
                sources = cmp.config.sources({
                    { name = "git" },
                }, {
                    { name = "buffer" },
                }),
            })
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })
        end,
    },
}

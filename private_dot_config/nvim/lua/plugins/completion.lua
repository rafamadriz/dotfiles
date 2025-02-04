-- NOTE: Keep notice of https://github.com/Saghen/blink.cmp as a simplier alternative to cmp

local config = function()
    local cmp = require "cmp"

    -- Stolen from wincent https://github.com/wincent/wincent/commit/5d6641ae1a36199a11529a8925b2f7d9516d9688
    -- Until https://github.com/hrsh7th/nvim-cmp/issues/1716
    -- (cmp.ConfirmBehavior.MatchSuffix) gets implemented, use this local wrapper
    -- to choose between `cmp.ConfirmBehavior.Insert` and
    -- `cmp.ConfirmBehavior.Replace`:
    local confirm = function(entry)
        local behavior = cmp.ConfirmBehavior.Replace
        if entry then
            local completion_item = entry.completion_item
            local newText = ""
            if completion_item.textEdit then
                newText = completion_item.textEdit.newText
            elseif type(completion_item.insertText) == "string" and completion_item.insertText ~= "" then
                newText = completion_item.insertText
            else
                newText = completion_item.word or completion_item.label or ""
            end

            -- How many characters will be different after the cursor position if we
            -- replace?
            local diff_after = math.max(0, entry.replace_range["end"].character + 1) - entry.context.cursor.col

            -- Does the text that will be replaced after the cursor match the suffix
            -- of the `newText` to be inserted? If not, we should `Insert` instead.
            if entry.context.cursor_after_line:sub(1, diff_after) ~= newText:sub(-diff_after) then
                behavior = cmp.ConfirmBehavior.Insert
            end
        end
        cmp.confirm { select = true, behavior = behavior }
    end

    cmp.setup {
        view = {
            entries = {
                follow_cursor = true,
            },
        },
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
            ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
            ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<C-y>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    local entry = cmp.get_selected_entry()
                    confirm(entry)
                else
                    fallback()
                end
            end, { "i", "s" }),
        },
        formatting = {
            format = function(entry, item)
                item.menu = ({
                    nvim_lsp = "[LSP]",
                    path = "[F]",
                    luasnip = "[S]",
                    buffer = "[B]",
                    nvim_lua = "[Lua]",
                })[entry.source.name]
                return item
            end,
        },
        sources = {
            { name = "nvim_lsp_signature_help" },
            { name = "nvim_lsp", priority = 1000, max_item_count = 10 },
            { name = "luasnip", priority = 15 },
            {
                name = "buffer",
                max_item_count = 5,
                priority = 1,
                option = {
                    get_bufnrs = function() return vim.api.nvim_list_bufs() end,
                    keyword_pattern = [[\k\+]],
                },
            },
            { name = "path" },
            { name = "nvim_lua" },
            { name = "lazydev", group_index = 0 },
        },
        experimental = {
            ghost_text = false,
        },
    }
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources {
            { name = "path" },
            { name = "cmdline" },
        },
    })

    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
        },
    })
end

return {
    {
        "hrsh7th/nvim-cmp",
        keys = { ":" },
        event = "InsertEnter",
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-nvim-lua" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
        },
        config = config,
    },
}

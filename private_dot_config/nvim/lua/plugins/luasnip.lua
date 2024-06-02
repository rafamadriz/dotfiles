return {
    "L3MON4D3/LuaSnip",
    event = { "InsertEnter" },
    config = function()
        local ls = require "luasnip"
        local types = require "luasnip.util.types"

        ls.config.set_config {
            history = true,
            -- Snippets aren't automatically removed if their text is deleted.
            -- `delete_check_events` determines on which events (:h events) a check for
            -- deleted snippets is performed.
            -- This can be especially useful when `history` is enabled.
            delete_check_events = "TextChanged",
            ext_opts = {
                [types.choiceNode] = {
                    active = {
                        virt_text = { { "choiceNode", "Comment" } },
                    },
                },
            },
            -- treesitter-hl has 100, use something higher (default is 200).
            ext_base_prio = 300,
            -- minimal increase in priority.
            ext_prio_increase = 1,
            enable_autosnippets = true,
            -- mapping for cutting selected text so it's usable as SELECT_DEDENT,
            -- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
            store_selection_keys = "<c-k>",
        }

        require("luasnip.loaders.from_lua").lazy_load { paths = { vim.fn.stdpath "config" .. "/lua/snippets" } }

        -- <c-l> is selecting within a list of options.
        vim.keymap.set({ "s", "i" }, "<c-l>", function()
            if ls.choice_active() then ls.change_choice(1) end
        end, { desc = "Scroll through choice nodes" })

        -- <c-k> is my expansion key
        -- this will expand the current item or jump to the next item within the snippet.
        vim.keymap.set({ "i", "s" }, "<c-k>", function()
            if ls.expand_or_jumpable() then ls.expand_or_jump() end
        end, { silent = true })

        -- <c-j> is my jump backwards key.
        -- this always moves to the previous item within the snippet
        vim.keymap.set({ "i", "s" }, "<c-j>", function()
            if ls.jumpable(-1) then ls.jump(-1) end
        end, { silent = true })
    end,
}

return {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = { "mikavilpas/blink-ripgrep.nvim", "ribru17/blink-cmp-spell" },
    version = "1.*",
    opts = {
        completion = {
            documentation = { auto_show = true },
            keyword = {
                -- 'prefix' will fuzzy match on the text before the cursor
                -- 'full' will fuzzy match on the text before _and_ after the cursor
                -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
                range = "full",
            },
            list = { selection = { auto_insert = false } },
            menu = {
                draw = {
                    columns = {
                        { "kind_icon", "label", "label_description", gap = 1 },
                        { "kind" },
                        { "source_name" },
                    },
                },
            },
        },

        signature = { enabled = true },
        snippets = { preset = "mini_snippets" },

        sources = {
            default = { "lazydev", "lsp", "path", "snippets", "buffer", "ripgrep", "spell" },
            providers = {
                lsp = {
                    score_offset = 200,
                },
                snippets = {
                    score_offset = 150,
                },
                path = {
                    opts = {
                        get_cwd = function() return vim.fn.getcwd() end,
                        show_hidden_files_by_default = true,
                    },
                },
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    -- make lazydev completions top priority (see `:h blink.cmp`)
                    score_offset = 100,
                },
                ripgrep = {
                    module = "blink-ripgrep",
                    name = "Ripgrep",
                    max_items = 3,
                    score_offset = -3,
                },
                spell = {
                    name = "Spell",
                    module = "blink-cmp-spell",
                    opts = {
                        -- Only enable source in `@spell` captures, and disable it in `@nospell` captures.
                        enable_in_context = function()
                            local curpos = vim.api.nvim_win_get_cursor(0)
                            local captures = vim.treesitter.get_captures_at_pos(0, curpos[1] - 1, curpos[2] - 1)
                            local in_spell_capture = false
                            for _, cap in ipairs(captures) do
                                if cap.capture == "spell" then
                                    in_spell_capture = true
                                elseif cap.capture == "nospell" then
                                    return false
                                end
                            end
                            return in_spell_capture
                        end,
                    },
                },
            },
        },
    },
}

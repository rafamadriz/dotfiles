local M = {}

M.config = function()
    if as._default(vim.g.code_treesitter_enabled) then
        require("nvim-treesitter.configs").setup {
            ensure_installed = vim.g.code_treesitter_parsers_install or "maintained",
            ignore_install = vim.g.code_treesitter_parsers_ignore or {},
            highlight = {
                enable = as._default(vim.g.code_treesitter_highlight), -- false will disable the whole extension
                use_languagetree = true,
            },
            indent = { enable = false },
            autopairs = { enable = true },
            playground = {
                enable = true,
                disable = {},
                updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
                persist_queries = false, -- Whether the query persists across vim sessions
                keybindings = {
                    toggle_query_editor = "o",
                    toggle_hl_groups = "i",
                    toggle_injected_languages = "t",
                    toggle_anonymous_nodes = "a",
                    toggle_language_display = "I",
                    focus_language = "f",
                    unfocus_language = "F",
                    update = "R",
                    goto_node = "<cr>",
                    show_help = "?",
                },
            },
        }
    end
end

return M

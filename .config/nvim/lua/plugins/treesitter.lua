if as._default(vim.g.neon_treesitter_enabled) then
    require("nvim-treesitter.configs").setup {
        ensure_installed = vim.g.neon_treesitter_parsers_install or "maintained",
        ignore_install = vim.g.neon_treesitter_parsers_ignore or {},
        highlight = {
            enable = true, -- false will disable the whole extension
            use_languagetree = true,
        },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<C-n>",
                node_incremental = "<C-n>",
                scope_incremental = "<C-s>",
            },
        },
    }
end

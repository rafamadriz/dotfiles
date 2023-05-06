return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        dependencies = { "nvim-treesitter/nvim-treesitter-context" },
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = "all",
                highlight = {
                    enable = true,
                    disable = { "html" },
                },
                indent = { enable = true },
                autotag = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gn",
                        node_incremental = "gn",
                        scope_incremental = nil,
                        node_decremental = "gN",
                    },
                },
            }
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        ft = {
            "html",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "svelte",
            "vue",
            "tsx",
            "jsx",
            "rescript",
            "xml",
            "php",
            "markdown",
            "astro",
            "glimmer",
            "handlebars",
            "hbs",
        },
    },
}

---@module "lazy"
---@type LazySpec
return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        dependencies = { "RRethy/nvim-treesitter-endwise" },
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "bash",
                    "c",
                    "comment",
                    "cpp",
                    "css",
                    "go",
                    "html",
                    "javascript",
                    "json",
                    "lua",
                    "luadoc",
                    "luap",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "query",
                    "regex",
                    "rust",
                    "tsx",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "yaml",
                    "zig",
                },
                highlight = {
                    enable = true,
                    disable = { "html" },
                },
                indent = { enable = true },
                endwise = { enable = true },
            }
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        lazy = false,
        opts = {},
    },
}

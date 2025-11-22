---@module "lazy"
---@type LazySpec
return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        dependencies = { "RRethy/nvim-treesitter-endwise" },
        config = function()
            local ts = require"nvim-treesitter"

            local parsers = {
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
            }

            local function get_parsers_to_install()
                local installed = ts.get_installed()
                local not_installed = {}

                for _, parser in pairs(parsers) do
                    if (not vim.tbl_contains(installed, parser)) then
                        table.insert(not_installed, parser)
                    end
                end

                return not_installed
            end

            ts.install(get_parsers_to_install())

            vim.api.nvim_create_autocmd('FileType', {
                pattern = ts.get_installed(),
                callback = function()
                    -- syntax highlighting, provided by Neovim
                    vim.treesitter.start()
                    -- indentation, provided by nvim-treesitter
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        lazy = false,
        opts = {},
    },
}

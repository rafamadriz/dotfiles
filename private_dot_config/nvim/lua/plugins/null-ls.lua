return {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "mason.nvim",
        "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
        local null_ls = require "null-ls"
        null_ls.setup {
            sources = {
                null_ls.builtins.diagnostics.shellcheck,
            },
        }

        require("mason-null-ls").setup {
            ensure_installed = nil,
            automatic_installation = true,
        }
    end,
}

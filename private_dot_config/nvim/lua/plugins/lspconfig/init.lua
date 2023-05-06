return {
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = {
            ensure_installed = { "lua_ls" },
            handlers = {
                function(server_name)
                    local config = require "plugins.lspconfig.servers"(server_name)
                    if config then require("lspconfig")[server_name].setup(config) end
                end,
            },
        },
        dependencies = {
            "mason.nvim",
            {
                "neovim/nvim-lspconfig",
                dependencies = {
                    { "cmp-nvim-lsp" },
                    {
                        "ray-x/lsp_signature.nvim",
                        opts = { max_width = 90, fix_pos = true, hint_prefix = " " },
                    },
                    {
                        "folke/neodev.nvim",
                        ft = "lua",
                        opts = { library = { plugins = { "nvim-dap-ui" } } },
                    },
                },
                config = function()
                    local lspconfig = require "lspconfig"
                    vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<CR>", { desc = "LSP info" })

                    require("lspconfig.ui.windows").default_options.border = "rounded"
                    lspconfig.util.default_config =
                        vim.tbl_extend("force", lspconfig.util.default_config, {
                            capabilities = require("cmp_nvim_lsp").default_capabilities(),
                        })
                end,
            },
        },
    },
}

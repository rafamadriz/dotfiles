return {
    {
        "williamboman/mason.nvim",
        event = "VeryLazy",
        config = true,
        dependencies = {
            {
                "williamboman/mason-lspconfig.nvim",
                config = function() require("mason-lspconfig").setup() end,
            },
            {
                "neovim/nvim-lspconfig",
                dependencies = {
                    "ray-x/lsp_signature.nvim",
                    opts = { max_width = 90, fix_pos = true, hint_prefix = " " },
                },
                config = function()
                    local lspconfig = require "lspconfig"
                    vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<CR>", { desc = "LSP info" })

                    require("lspconfig.ui.windows").default_options.border = "rounded"
                    lspconfig.util.default_config =
                        vim.tbl_extend("force", lspconfig.util.default_config, {
                            capabilities = require("cmp_nvim_lsp").default_capabilities(),
                        })

                    require("mason-lspconfig").setup_handlers {
                        function(server_name) lspconfig[server_name].setup {} end,

                        ["lua_ls"] = function()
                            lspconfig.lua_ls.setup {
                                settings = {
                                    Lua = {
                                        completion = { callSnippet = "Replace" },
                                        -- This won't work, hints are not implemented yet in neovim
                                        -- reference: https://github.com/neovim/neovim/issues/18086
                                        hint = { enable = true },
                                        diagnostics = {
                                            globals = { "vim" },
                                        },
                                        workspace = {
                                            -- Make the server aware of Neovim runtime files
                                            library = vim.api.nvim_get_runtime_file("", true),
                                            checkThirdParty = false,
                                        },
                                        telemetry = {
                                            enable = false,
                                        },
                                    },
                                },
                            }
                        end,
                    }
                end,
            },
        },
    },
}

-- Fix for https://github.com/rafamadriz/dotfiles/issues/2
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion = {
    dynamicRegistration = false,
    completionItem = {
        snippetSupport = true,
        commitCharactersSupport = true,
        deprecatedSupport = true,
        preselectSupport = true,
        tagSupport = {
            valueSet = {
                1,
            },
        },
        insertReplaceSupport = true,
        resolveSupport = {
            properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
                "sortText",
                "filterText",
                "insertText",
                "textEdit",
                "insertTextFormat",
                "insertTextMode",
            },
        },
        insertTextModeSupport = {
            valueSet = {
                1,
                2,
            },
        },
        labelDetailsSupport = true,
    },
    contextSupport = true,
    insertTextMode = 1,
    completionList = {
        itemDefaults = {
            "commitCharacters",
            "editRange",
            "insertTextFormat",
            "insertTextMode",
            "data",
        },
    },
}

return {
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- Library items can be absolute paths
                -- "~/projects/my-awesome-lib",
                -- Or relative, which means they will be resolved as a plugin
                -- "LazyVim",
                -- When relative, you can also provide a path to the library in the plugin dir
                "luvit-meta/library", -- see below
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            ensure_installed = vim.tbl_keys(require("plugins.lspconfig.servers").servers),
            handlers = {
                function(server_name)
                    local config = require("plugins.lspconfig.servers").config(server_name)
                    if config then require("lspconfig")[server_name].setup(config) end
                end,
            },
        },
        dependencies = {
            "mason.nvim",
            {
                "neovim/nvim-lspconfig",
                dependencies = { "saghen/blink.cmp" },
                config = function()
                    vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<CR>", { desc = "LSP info" })

                    local lspconfig = require "lspconfig"

                    -- Setup ccls with lspconfig since it's not going to be supported by mason.nvim
                    -- Source: https://github.com/williamboman/mason.nvim/issues/349
                    if vim.fn.executable "ccls" then
                        lspconfig["ccls"].setup {
                            init_options = {
                                cache = {
                                    directory = vim.fn.stdpath "cache" .. "/ccls-cache",
                                },
                            },
                        }
                    end

                    require("lspconfig.ui.windows").default_options.border = "rounded"
                    lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
                        capabilities = require("blink.cmp").get_lsp_capabilities(capabilities),
                    })
                end,
            },
        },
    },
}

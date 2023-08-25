return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            require("lualine").setup {
                options = {
                    -- section_separators = "",
                    -- component_separators = "",
                    -- component_separators = { left = "", right = "" },
                    -- section_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        {
                            "filetype",
                            icon_only = true,
                            separator = "",
                            padding = { left = 1, right = 0 },
                        },
                        {
                            "filename",
                            path = 4,
                            symbols = { modified = "", readonly = "[RO]" },
                            color = { gui = "italic,bold" },
                        },
                    },
                    lualine_c = {
                        { "branch", separator = "", padding = { left = 1, right = 0 } },
                        "diff",
                    },
                    lualine_x = {
                        {
                            "diagnostics",
                            symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
                            separator = "",
                        },
                        {
                            function()
                                local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
                                if #buf_clients == 0 then return "" end

                                local buf_client_names = {}
                                for _, client in pairs(buf_clients) do
                                    table.insert(buf_client_names, client.name)
                                end

                                local uniq_client_names = table.concat(vim.fn.uniq(buf_client_names), ", ")
                                local language_servers = string.format(" [%s]", uniq_client_names)

                                return language_servers
                            end,
                            color = { gui = "bold" },
                        },
                    },
                    lualine_y = {
                        { "encoding", separator = "┃" },
                        "fileformat",
                    },
                    lualine_z = {
                        {
                            function()
                                local line, fmt = vim.fn.line, string.format
                                local col = vim.fn.virtcol
                                return fmt("Ln %3d/%-4d, Col %-3d", line ".", line "$", col ".")
                            end,
                            padding = { left = 1, right = 1 },
                            separator = "",
                        },
                    },
                },

                extensions = { "quickfix", "neo-tree", "lazy" },
            }
        end,
    },
    {
        "stevearc/dressing.nvim",
        lazy = false,
        config = function()
            require("dressing").setup {
                input = {
                    insert_only = false,
                },
            }
        end,
    },
    {
        "uga-rosa/ccc.nvim",
        ft = { "typescript", "typescriptreact", "javascriptreact", "html", "css" },
        cmd = { "CccPick", "CccHighlighterToggle" },
        opts = { highlighter = { auto_enable = true } },
    },
}

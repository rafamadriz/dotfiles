return {
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        config = function()
            require("lualine").setup {
                options = {
                    -- section_separators = "",
                    -- component_separators = "",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    -- section_separators = { left = "", right = "" },
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
                            color = { gui = "bold" },
                            separator = "",
                        },
                        -- {
                        --     function()
                        --         local buf_clients = vim.lsp.get_clients { bufnr = 0 }
                        --         if #buf_clients == 0 then return "" end
                        --
                        --         local buf_client_names = {}
                        --         for _, client in pairs(buf_clients) do
                        --             table.insert(buf_client_names, client.name)
                        --         end
                        --
                        --         local uniq_client_names = table.concat(vim.fn.uniq(buf_client_names), ", ")
                        --         local language_servers = string.format(" [%s]", uniq_client_names)
                        --
                        --         return language_servers
                        --     end,
                        --     color = { gui = "bold" },
                        -- },
                    },
                    lualine_y = {
                        { "encoding", separator = "┃" },
                        "fileformat",
                    },
                    lualine_z = {
                        {
                            function()
                                local pos = vim.fn.getcurpos()
                                local line, column = pos[2], pos[3]
                                local height = vim.api.nvim_buf_line_count(0)

                                local str = " "
                                local padding = #tostring(height) - #tostring(line)
                                if padding > 0 then str = str .. (" "):rep(padding) end

                                str = str .. "ℓ "
                                str = str .. line
                                str = str .. " c "
                                str = str .. column
                                str = str .. " "

                                if #tostring(column) < 2 then str = str .. " " end
                                return str
                            end,
                            padding = { left = 0, right = 0 },
                        },
                    },
                },

                extensions = { "quickfix", "neo-tree", "lazy", "oil", "mason", "fzf" },
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

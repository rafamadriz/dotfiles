return {
    "stevearc/conform.nvim",
    lazy = false,
    init = function()
        vim.api.nvim_create_user_command("Format", function(args)
            local range = nil
            if args.count ~= -1 then
                local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                range = {
                    start = { args.line1, 0 },
                    ["end"] = { args.line2, end_line:len() },
                }
            end
            require("conform").format { async = true, lsp_fallback = true, range = range }
        end, { range = true })
    end,
    config = function()
        require("conform").setup {
            format_on_save = {
                -- These options will be passed to conform.format()
                timeout_ms = 500,
                lsp_fallback = true,
            },
            formatters_by_ft = {
                -- Conform will run multiple formatters sequentially
                -- python = { "isort", "black" },
                c = { "clangformat" },
                css = { "prettier" },
                go = { "goimports" },
                html = { "prettier" },
                -- Use a sub-list to run only the first available formatter
                javascript = { { "prettierd", "prettier" } },
                javascriptreact = { "prettier" },
                json = { "prettier" },
                lua = { "stylua" },
                markdown = { "prettier" },
                rust = { "rustfmt" },
                sh = { "shfmt" },
                toml = { "taplo" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                zig = { "zigfmt" },
            },
        }
    end,
}

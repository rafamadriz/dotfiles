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

require("conform").setup {
    format_on_save = nil,
    formatters_by_ft = {
        -- Conform will run multiple formatters sequentially
        -- python = { "isort", "black" },
        c = { "clang-format" },
        css = { "prettier" },
        go = { "goimports" },
        html = { "prettier" },
        -- Use a sub-list to run only the first available formatter
        javascript = { "prettierd", "prettier" },
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
vim.keymap.set({ "n", "v" }, "<leader>=", "<cmd>Format<CR>", { desc = "Format buffer" })

local M = {}

M.ai = function()
    local ai = require "mini.ai"
    require("mini.ai").setup {
        n_lines = 500,
        mappings = { around_last = "", inside_last = "" },
        custom_textobjects = {
            i = ai.gen_spec.treesitter({ a = "@conditional.outer", i = "@conditional.inner" }, {}),
            f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
            c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
    }
end

M.operators = function()
    require("mini.operators").setup {
        exchange = { prefix = "gx" },
        replace = { prefix = "gX" },
        multiply = { prefix = "" },
        sort = { prefix = "" },
        evaluate = { prefix = "" },
    }
end

M.git = function()
    local git = require "mini.git"
    git.setup {}
    vim.cmd.cnoreabbrev "G Git"

    vim.api.nvim_create_autocmd("Filetype", {
        pattern = { "git", "diff" },
        callback = function(args)
            if not vim.api.nvim_buf_is_valid(args.buf) then return end
            local buf_name = vim.api.nvim_buf_get_name(args.buf)
            if not vim.startswith(buf_name, "minigit://") then return end

            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.MiniGit.diff_foldexpr()"

            vim.keymap.set({ "n", "x" }, "K", git.show_at_cursor, { buffer = args.buf, desc = "Show git data" })
            vim.keymap.set({ "n", "x" }, "gd", git.show_diff_source, { buffer = args.buf, desc = "Go to git source" })
        end,
    })
end

return {
    {
        "echasnovski/mini.nvim",
        lazy = false,
        version = false,
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        config = function()
            M.ai()
            M.operators()
            M.git()
            require("mini.align").setup {}
        end,
    },
}

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
        exchange = { prefix = "cx" },
        multiply = { prefix = "cm" },
        replace = { prefix = "cr" },
        sort = { prefix = "" },
    }
end

return {
    {
        "echasnovski/mini.nvim",
        lazy = false,
        version = false,
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        config = function()
            M.ai()
            require("mini.align").setup {}
            M.operators()
        end,
    },
}

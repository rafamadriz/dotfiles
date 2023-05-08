return {
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        config = function()
            local ai = require "mini.ai"
            require("mini.ai").setup {
                n_lines = 500,
                mappings = { around_last = "", inside_last = "" },
                custom_textobjects = {
                    i = ai.gen_spec.treesitter(
                        { a = "@conditional.outer", i = "@conditional.inner" },
                        {}
                    ),
                    f = ai.gen_spec.treesitter(
                        { a = "@function.outer", i = "@function.inner" },
                        {}
                    ),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                },
            }
        end,
    },
    {
        "echasnovski/mini.align",
        keys = { { "ga", mode = { "n", "v" } }, { "gA", mode = { "n", "v" } } },
        config = function() require("mini.align").setup {} end,
    },
    {
        "echasnovski/mini.jump",
        event = "VeryLazy",
        config = function() require("mini.jump").setup {} end,
    },
    {
        "echasnovski/mini.splitjoin",
        keys = { "gS" },
        config = function() require("mini.splitjoin").setup {} end,
    },
}

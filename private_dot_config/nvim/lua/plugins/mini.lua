return {
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        config = function()
            require("mini.ai").setup { mappings = { around_last = "", inside_last = "" } }
        end,
    },
    {
        "echasnovski/mini.align",
        keys = { { "ga", mode = { "n", "v" } }, { "gA", mode = { "n", "v" } } },
        config = function() require("mini.align").setup {} end,
    },
    {
        "echasnovski/mini.bracketed",
        keys = { "[", "]" },
        config = function()
            require("mini.bracketed").setup {
                comment = { suffix = "" },
            }
        end,
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

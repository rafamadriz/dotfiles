return {
    -- Required by others
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },

    -- Improve editing experience and motions
    {
        "numToStr/Comment.nvim",
        keys = {
            "gcc",
            "gbc",
            "gcA",
            "gco",
            "gcO",
            { "gc", mode = { "n", "v" } },
            { "gb", mode = { "n", "v" } },
        },
        config = function()
            require("Comment").setup {
                ignore = "^$",
            }
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup {
                disable_filetype = { "TelescopePrompt", "vim" },
                ignored_next_char = "[%w%.]",
            }
        end,
    },
    {
        "kylechui/nvim-surround",
        keys = {
            "ys",
            "yss",
            "ds",
            "cs",
            { "ys", mode = { "v" } },
            { "<C-g>s", mode = { "i" } },
            { "<C-g>S", mode = { "i" } },
        },
        config = function()
            require("nvim-surround").setup {
                keymaps = {
                    visual = "ys",
                    visual_line = false,
                },
            }
        end,
    },
    {
        "ggandor/leap.nvim",
        keys = { { "s", mode = { "n", "v" } }, { "S", mode = { "n", "v" } }, "gs" },
        config = function()
            local leap = require "leap"
            leap.add_default_mappings()
        end,
    },

    -- Other useful utils
    {
        "NMAC427/guess-indent.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = true,
    },
}

return {
    -- Required by others
    { "nvim-lua/plenary.nvim" },
    { "kyazdani42/nvim-web-devicons" },

    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = "all",
                highlight = {
                    enable = true,
                    disable = { "html" },
                },
                indent = { enable = false },
                autotag = { enable = true },
            }
        end
    },

    -- Improve editing experience and motions
    {
        "numToStr/Comment.nvim",
        keys = {"gcc", "gbc", "gcA", "gco", "gcO", {"gc", mode = {"n", "v"}}, {"gb", mode = {"n", "v"}}},
        config = function()
            require("Comment").setup {
                ignore = "^$",
            }
        end,
    },
    {
        "kylechui/nvim-surround",
        keys = { "ys", "yss", "ds", "cs", {"S", mode = {"v"}}, {"<C-g>s", mode = {"i"}}, {"<C-g>S", mode = {"i"}}},
        config = function() require("nvim-surround").setup {
                keymaps = {
                    visual_line = false,
                },
        } end,
    },
    {
        "ggandor/leap.nvim",
        keys = {{"s", mode = {"n", "v"}}, {"S", mode = {"n", "v"}}, "gs"},
        config = function()
            local leap = require('leap')
            leap.add_default_mappings()
        end,
    }
}

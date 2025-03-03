-- plugins to check in the future:
-- https://github.com/MagicDuck/grug-far.nvim
-- https://github.com/Saghen/blink.cmp
return {
    -- Required by others
    { "nvim-lua/plenary.nvim" },

    -- Package manager
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        config = true,
    },

    -- Improve editing experience and motions
    {
        "folke/ts-comments.nvim",
        opts = {},
        event = "VeryLazy",
        enabled = vim.fn.has "nvim-0.10.0" == 1,
    },
    {
        "kylechui/nvim-surround",
        keys = {
            "ys",
            "yss",
            "ds",
            "cs",
            { "ys", mode = { "v" } },
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
        lazy = false,
        init = function()
            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function() vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" }) end,
            })
        end,
        config = function()
            local leap = require "leap"
            -- leap.opts.safe_labels = {}
            leap.add_default_mappings()
            leap.init_highlight(true)
            leap.opts.special_keys.prev_target = "<backspace>"
        end,
    },
    {
        "ggandor/flit.nvim",
        keys = { "f", "F", "t", "T" },
        opts = {
            keys = { f = "f", F = "F", t = "t", T = "T" },
            -- A string like "nv", "nvo", "o", etc.
            labeled_modes = "v",
            multiline = false,
            -- Like `leap`s similar argument (call-specific overrides).
            -- E.g.: opts = { equivalence_classes = {} }
            opts = {},
        },
    },

    -- Chezmoi
    {
        "alker0/chezmoi.vim",
        lazy = false,
        init = function()
            -- This option is required.
            vim.g["chezmoi#use_tmp_buffer"] = true
        end,
    },

    -- Other useful tools
    {
        "zk-org/zk-nvim",
        lazy = false,
        config = function()
            require("zk").setup {
                picker = "fzf_lua",
            }
        end,
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
    },
    { "kevinhwang91/nvim-bqf", ft = "qf" },
    { "hiphish/rainbow-delimiters.nvim", lazy = false },
    {
        "NMAC427/guess-indent.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = true,
    },
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Undotree" } },
        config = function()
            vim.g.undotree_WindowLayout = 4
            vim.g.undotree_SplitWidth = 45
            vim.g.undotree_SetFocusWhenToggle = 1
        end,
    },
}

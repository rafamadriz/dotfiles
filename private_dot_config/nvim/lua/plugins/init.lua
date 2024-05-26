return {
    -- Required by others
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },

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
            leap.opts.safe_labels = {}
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

    -- Other useful tools
    { "kevinhwang91/nvim-bqf", ft = "qf" },
    {
        "ahmedkhalf/project.nvim",
        lazy = false,
        config = function()
            require("project_nvim").setup {
                detection_methods = { "pattern", "lsp" },
                show_hidden = true, -- show hidden files in telescope
            }
        end,
    },
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
    {
        "ThePrimeagen/harpoon",
        keys = {
            { "<C-\\>", function() require("harpoon.ui").toggle_quick_menu() end },
            { "<leader>a", function() require("harpoon.mark").add_file() end },
            { "<leader>1", function() require("harpoon.ui").nav_file(1) end },
            { "<leader>2", function() require("harpoon.ui").nav_file(2) end },
            { "<leader>3", function() require("harpoon.ui").nav_file(3) end },
            { "<leader>4", function() require("harpoon.ui").nav_file(4) end },
        },
    },
}

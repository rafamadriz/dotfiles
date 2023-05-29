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
        end,
    },

    -- Other useful tools
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
        "danymat/neogen",
        cmd = { "Neogen" },
        dependencies = "nvim-treesitter",
        opts = {
            snippet_engine = "luasnip",
        },
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
            vim.g.undotree_WindowLayout = 2
            vim.g.undotree_SplitWidth = 45
            vim.g.undotree_SetFocusWhenToggle = 1
        end,
    },
}

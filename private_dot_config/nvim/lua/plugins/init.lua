-- plugins to check in the future:
-- https://github.com/MagicDuck/grug-far.nvim
---@module "lazy"
---@type LazySpec
return {
    -- Required by others
    { "nvim-lua/plenary.nvim" },

    -- Package manager
    {
        "mason-org/mason.nvim",
        lazy = false,
        build = ":MasonUpdate",
        config = true,
    },

    --- LSP
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        keys = { { "<leader>li", "<cmd>LspInfo<CR>", desc = "Info" } },
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "Bekaboo/dropbar.nvim",
        lazy = false,
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
        "andrewferrier/debugprint.nvim",
        lazy = false,
        version = "*",
        opts = {
            keymaps = {
                normal = {
                    plain_below = "<leader>d?p",
                    plain_above = "<leader>d?P",
                    variable_below = "<leader>d?v",
                    variable_above = "<leader>d?V",
                    surround_plain = "<leader>d?sp",
                    surround_variable = "<leader>d?sv",
                    textobj_below = "<leader>d?o",
                    textobj_above = "<leader>d?O",
                    textobj_surround = "<leader>d?so",
                },
                visual = {
                    variable_below = "<leader>d?v",
                    variable_above = "<leader>d?V",
                },
            }
        },
    },
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
        opts = {
            checkbox = { checked = { scope_highlight = "@markup.strikethrough" } },
            anti_conceal = {
                enabled = false,
            },
        },
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

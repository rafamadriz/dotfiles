local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

local opts = {
    defaults = {
        lazy = true,
        version = "*",
    },
    install = {
        colorscheme = { "kanagawa" },
    },
}

require("lazy").setup({
    -----------------------------------------------------------------------------//
    -- Required by others {{{1
    -----------------------------------------------------------------------------//
    { "nvim-lua/plenary.nvim" },
    { "kyazdani42/nvim-web-devicons" },
    -----------------------------------------------------------------------------//
    -- LSP {{{1
    -----------------------------------------------------------------------------//
    {
        "williamboman/mason.nvim",
        event = "BufRead",
        config = function() require("mason").setup() end,
        dependencies = {
            {
                "williamboman/mason-lspconfig.nvim",
                config = function() require("mason-lspconfig").setup() end,
            },
            {
                "neovim/nvim-lspconfig",
                config = function() require "plugins.lspconfig" end,
            },
        },
    },
    { "ray-x/lsp_signature.nvim" },
    -----------------------------------------------------------------------------//
    -- Completion and snippets {{{1
    -----------------------------------------------------------------------------//
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            { "petertriho/cmp-git", ft = { "NeogitCommitMessage", "gitcommit" } },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-nvim-lua" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-cmdline" },
        },
        config = function() require "plugins.completion" end,
    },
    {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        config = function() require "plugins.snippets" end,
    },
    -----------------------------------------------------------------------------//
    -- Telescope {{{1
    -----------------------------------------------------------------------------//
    {
        "nvim-telescope/telescope.nvim",
        lazy = false,
        config = function() require "plugins.telescope" end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },
    -----------------------------------------------------------------------------//
    -- Treesitter {{{1
    -----------------------------------------------------------------------------//
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = function() require("nvim-treesitter.install").update { with_sync = true } end,
        config = function() require "plugins.treesitter" end,
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-context" },
        },
    },
    {
        "windwp/nvim-ts-autotag",
        ft = {
            "html",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "svelte",
            "vue",
            "tsx",
            "jsx",
            "rescript",
            "xml",
            "php",
            "markdown",
        },
    },
    -----------------------------------------------------------------------------//
    -- Improve Editing and motions {{{1
    -----------------------------------------------------------------------------//
    {
        "echasnovski/mini.ai",
        config = function() require("mini.ai").setup() end,
        lazy = false,
    },
    {
        "kylechui/nvim-surround",
        lazy = false,
        config = function() require("nvim-surround").setup {} end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup {
                disable_filetype = { "TelescopePrompt", "vim" },
            }
        end,
    },
    {
        "numToStr/Comment.nvim",
        keys = { "gcc", "gc", "gb" },
        config = function()
            require("Comment").setup {
                ignore = "^$",
            }
        end,
    },
    -----------------------------------------------------------------------------//
    -- Git {{{1
    -----------------------------------------------------------------------------//
    {
        "lewis6991/gitsigns.nvim",
        event = "BufRead",
        config = function() require("plugins.git").gitsigns() end,
    },
    {
        "TimUntersberger/neogit",
        cmd = "Neogit",
        config = function() require("plugins.git").neogit() end,
    },
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        config = function() require("plugins.git").diffview() end,
    },
    -----------------------------------------------------------------------------//
    -- UI {{{1
    -----------------------------------------------------------------------------//
    { "sainnhe/gruvbox-material" },
    { "rebelot/kanagawa.nvim", lazy = false },
    { "sainnhe/edge" },
    { "projekt0n/github-nvim-theme" },
    {
        "goolord/alpha-nvim",
        lazy = false,
        config = function() require "plugins.alpha" end,
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            require("lualine").setup {
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "" },
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = { "diagnostics", "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            }
        end,
    },
    {
        "stevearc/dressing.nvim",
        lazy = false,
        config = function()
            require("dressing").setup {
                input = {
                    insert_only = false,
                },
            }
        end,
    },
    {
        "NvChad/nvim-colorizer.lua",
        cmd = { "ColorizerToggle", "ColorizerAttachToBuffer" },
        config = function()
            require("colorizer").setup {
                filetypes = { "*" },
                user_default_options = {
                    RGB = true, -- #RGB hex codes
                    RRGGBB = true, -- #RRGGBB hex codes
                    names = true, -- "Name" codes like Blue or blue
                    RRGGBBAA = true, -- #RRGGBBAA hex codes
                    AARRGGBB = true, -- 0xAARRGGBB hex codes
                    rgb_fn = true, -- CSS rgb() and rgba() functions
                    hsl_fn = true, -- CSS hsl() and hsla() functions
                    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                    css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                    -- Available modes for `mode`: foreground, background,  virtualtext
                    mode = "background", -- Set the display mode.
                    tailwind = true, -- Enable tailwind colors
                    -- parsers can contain values used in |user_default_options|
                    sass = { enable = true }, -- Enable sass colors
                },
            }
        end,
    },
    --------------------------------------------------------------------------------
    -- Project and session management {{{1
    --------------------------------------------------------------------------------
    {
        "stevearc/overseer.nvim",
        lazy = false,
        config = function() require("overseer").setup() end,
    },
    { "kevinhwang91/nvim-bqf", ft = "qf" },
    {
        "nvim-neo-tree/neo-tree.nvim",
        lazy = false,
        config = function() require "plugins.neotree" end,
        dependencies = { "MunifTanjim/nui.nvim" },
    },
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
        "Shatur/neovim-session-manager",
        lazy = false,
        config = function()
            require("session_manager").setup {
                autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
            }
        end,
    },
    -----------------------------------------------------------------------------//
    -- General plugins {{{1
    -----------------------------------------------------------------------------//
    {
        "mhartington/formatter.nvim",
        cmd = { "Format", "FormatWrite" },
        config = function() require "plugins.format" end,
    },
    {
        "folke/which-key.nvim",
        lazy = false,
        config = function() require "plugins.whichkey" end,
    },
    {
        "mickael-menu/zk-nvim",
        lazy = false,
        config = function() require "plugins.zk" end,
    },
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        config = function()
            vim.g.undotree_WindowLayout = 2
            vim.g.undotree_SplitWidth = 40
            vim.g.undotree_SetFocusWhenToggle = 1
            vim.g.undotree_ShortIndicators = 1
        end,
    },
}, opts)

-- }}}
-- vim:foldmethod=marker

local pack_use = function()
    local use = require("packer").use
    use { "wbthomason/packer.nvim" }
    -----------------------------------------------------------------------------//
    -- Required by others {{{1
    -----------------------------------------------------------------------------//
    use { "nvim-lua/plenary.nvim", module = "plenary" }
    use { "kyazdani42/nvim-web-devicons", module = "nvim-web-devicons" }
    -----------------------------------------------------------------------------//
    -- LSP {{{1
    -----------------------------------------------------------------------------//
    use { "ray-x/lsp_signature.nvim" }
    use {
        "williamboman/nvim-lsp-installer",
        {
            "neovim/nvim-lspconfig",
            config = function()
                require "plugins.lspconfig"
            end
        }
    }
    -----------------------------------------------------------------------------//
    -- Completion and snippets {{{1
    -----------------------------------------------------------------------------//
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },
            { "saadparwaiz1/cmp_luasnip" },
        },
        config = function() require "plugins.completion" end,
    }
    use {
        "L3MON4D3/LuaSnip",
        config = function() require "plugins.snippets" end,
    }
    -----------------------------------------------------------------------------//
    -- Telescope {{{1
    -----------------------------------------------------------------------------//
    use {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
    }
    use {
        "nvim-telescope/telescope.nvim",
        config = function() require "plugins.telescope" end,
    }
    -----------------------------------------------------------------------------//
    -- Treesitter {{{1
    -----------------------------------------------------------------------------//
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function() require "plugins.treesitter" end,
    }
    use { "windwp/nvim-ts-autotag" }
    -----------------------------------------------------------------------------//
    -- Utils {{{1
    -----------------------------------------------------------------------------//
    use { "alker0/chezmoi.vim" }
    use {
        "phaazon/hop.nvim",
    }
    use {
        "rhysd/clever-f.vim",
        config = function()
            vim.g.clever_f_across_no_line = 1
            vim.cmd "map ; <Plug>(clever-f-repeat-forward)"
            vim.cmd "map , <Plug>(clever-f-repeat-back)"
        end,
    }
    use {
        "folke/which-key.nvim",
        config = function()
            require "plugins.whichkey"
        end
    }
    use {
        "kyazdani42/nvim-tree.lua",
        requires = "nvim-web-devicons",
        config = function() require 'plugins.tree' end
    }
    -----------------------------------------------------------------------------//
    -- Improve Editing {{{1
    -----------------------------------------------------------------------------//
    use { "wellle/targets.vim" }
    use { "machakann/vim-sandwich" }
    use {
        "windwp/nvim-autopairs",
        config = function()
            require('nvim-autopairs').setup {
                disable_filetype = { "TelescopePrompt", "vim" },
            }
        end,
    }
    use {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup {
                ignore = "^$",
            }
        end,
    }
    -----------------------------------------------------------------------------//
    -- Git {{{1
    -----------------------------------------------------------------------------//
    use {
        "lewis6991/gitsigns.nvim",
        requires = "plenary.nvim",
        config = function() require "plugins.git".gitsigns() end,
    }
    use {
        "TimUntersberger/neogit",
        config = function() require "plugins.git".neogit() end,
    }
    use {
        "sindrets/diffview.nvim",
        config = function() require "plugins.git".diffview() end,
    }
    -----------------------------------------------------------------------------//
    -- UI {{{1
    -----------------------------------------------------------------------------//
    use "rafamadriz/themes.nvim"
    use { "stevearc/dressing.nvim",
        config = function()
            require('dressing').setup {
                input = {
                    insert_only = false,
                },
                select = {
                    telescope = require('telescope.themes').get_cursor()
                }
            }
        end
    }
    -----------------------------------------------------------------------------//
    -- General plugins {{{1
    -----------------------------------------------------------------------------//
    use { "kevinhwang91/nvim-bqf", ft = "qf" }
    use {
        "mickael-menu/zk-nvim",
    }
    use {
        "ahmedkhalf/project.nvim",
    }
    use {
        "mbbill/undotree",
        config = function()
            vim.g.undotree_WindowLayout = 2
            vim.g.undotree_SplitWidth = 40
            vim.g.undotree_SetFocusWhenToggle = 1
            vim.g.undotree_ShortIndicators = 1
            as.nnoremap('<leader>u', '<cmd>UndotreeToggle<CR>', { desc = "Undo history" })
        end,
    }
    use {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({ "html", "javascript", "css" }, {
                RRGGBBAA = true,
                rgb_fn = true,
                hsl_fn = true,
                css = true,
                css_fn = true,
            })
        end,
    }
end
-- }}}

local fn = vim.fn
local install_path = fn.stdpath('data') .. "/site/pack/packer/start/packer.nvim"

local function load_plugins()
    local pack = require "packer"
    pack.init {
        compile_path = install_path .. "/plugin/packer_compiled.lua",
        git = { clone_timeout = 600 },
    }
    pack.startup {
        function()
            pack_use()
        end,
    }
end

if fn.empty(fn.glob(install_path)) > 0 then
    vim.cmd("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    load_plugins()
    require("packer").sync()
else
    load_plugins()
end
-- vim:foldmethod=marker

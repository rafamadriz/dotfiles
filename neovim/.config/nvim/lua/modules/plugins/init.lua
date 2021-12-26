require "impatient" -- Improve startup a little.
local pack_use = function()
    local use = require("packer").use
    use { "wbthomason/packer.nvim" }
    -- NOTE: this is plugin is unnecessary once https://github.com/neovim/neovim/pull/15436 is merged
    use { "lewis6991/impatient.nvim" }
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
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        config = function()
            require "modules.lsp"
        end,
    }
    use {
        "williamboman/nvim-lsp-installer",
        after = "nvim-lspconfig",
        config = function()
            require "modules.lsp.servers"
        end,
    }
    -----------------------------------------------------------------------------//
    -- Completion and snippets {{{1
    -----------------------------------------------------------------------------//
    use {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        requires = {
            { "hrsh7th/cmp-path", after = "nvim-cmp" },
            { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
            { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
            { "f3fora/cmp-spell", after = "nvim-cmp" },
            { "saadparwaiz1/cmp_luasnip", after = "LuaSnip" },
        },
        config = function()
            require("modules.plugins.completion").setup()
        end,
    }
    use {
        "L3MON4D3/LuaSnip",
        after = "nvim-cmp",
        config = function()
            require("luasnip").config.set_config {
                history = true,
            }
            require("luasnip.loaders.from_vscode").load {}
        end,
    }
    use { "rafamadriz/friendly-snippets" }
    -----------------------------------------------------------------------------//
    -- Telescope {{{1
    -----------------------------------------------------------------------------//
    use {
        "nvim-telescope/telescope-fzf-native.nvim",
        cmd = "Telescope",
        run = "make",
    }
    use {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        config = function()
            require("modules.plugins.telescope").config()
        end,
    }
    -----------------------------------------------------------------------------//
    -- Treesitter {{{1
    -----------------------------------------------------------------------------//
    use {
        "nvim-treesitter/playground",
        cmd = { "TSHighlightCapturesUnderCursor", "TSPlaygroundToggle" },
    }
    use {
        "nvim-treesitter/nvim-treesitter",
        branch = "0.5-compat",
        run = ":TSUpdate",
        event = "BufRead",
        config = function()
            require("modules.plugins.treesitter").config()
        end,
    }
    -----------------------------------------------------------------------------//
    -- Utils {{{1
    -----------------------------------------------------------------------------//
    use {
        "phaazon/hop.nvim",
        cmd = { "HopChar2" },
        config = function()
            require("hop").setup()
        end,
    }
    use {
        "rhysd/clever-f.vim",
        keys = { "f", "F", "t", "T" },
        config = function()
            vim.g.clever_f_across_no_line = 1
            vim.cmd "map ; <Plug>(clever-f-repeat-forward)"
            vim.cmd "map , <Plug>(clever-f-repeat-back)"
        end,
    }
    use {
        "folke/which-key.nvim",
        event = "BufWinEnter",
        config = function()
            require("modules.plugins.which-key").config()
        end,
    }
    use {
        "mhartington/formatter.nvim",
        cmd = { "Format", "FormatWrite" },
        config = function()
            require("modules.plugins.formatter").config()
        end,
    }
    use {
        "kyazdani42/nvim-tree.lua",
        requires = "nvim-web-devicons",
        config = function()
            require("modules.plugins.filetree").config()
        end,
    }
    use {
        "akinsho/toggleterm.nvim",
        keys = "<A-t>",
        cmd = "ToggleTerm",
        config = function()
            require("toggleterm").setup {
                size = 20,
                direction = "horizontal",
                open_mapping = [[<a-t>]],
            }
        end,
    }
    -----------------------------------------------------------------------------//
    -- Improve Editing {{{1
    -----------------------------------------------------------------------------//
    use { "tommcdo/vim-exchange", keys = { { "n", "cx" }, { "v", "X" } } }
    use { "machakann/vim-sandwich", event = { "BufRead", "InsertLeave" } }
    use {
        "windwp/nvim-autopairs",
        after = "nvim-cmp",
        config = function()
            require("modules.plugins.completion").autopairs()
        end,
    }
    use {
        "numToStr/Comment.nvim",
        keys = { "gcc", "gc" },
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
        event = "BufRead",
        requires = "plenary.nvim",
        config = function()
            require("modules.plugins.git").gitsigns()
        end,
    }
    use {
        "TimUntersberger/neogit",
        cmd = "Neogit",
        config = function()
            require("modules.plugins.git").neogit()
        end,
    }
    use {
        "sindrets/diffview.nvim",
        opt = true,
        after = "neogit",
        cmd = "DiffviewOpen",
        config = function()
            require("modules.plugins.git").diffview()
        end,
    }
    use {
        "ruifm/gitlinker.nvim",
        opt = true,
        requires = "plenary.nvim",
        keys = { "<leader>gy" },
        config = function()
            require("modules.plugins.git").gitlinker()
        end,
    }
    -----------------------------------------------------------------------------//
    -- UI {{{1
    -----------------------------------------------------------------------------//
    use "rafamadriz/themes.nvim"
    use {
        "rafamadriz/statusline",
        config = function()
            require("modules.plugins.statusline").config()
        end,
    }
    use {
        "goolord/alpha-nvim",
        config = function()
            require("modules.plugins.alpha").config()
        end,
    }
    -----------------------------------------------------------------------------//
    -- General plugins {{{1
    -----------------------------------------------------------------------------//
    use { "kevinhwang91/nvim-bqf", ft = "qf" }
    use {
        "folke/persistence.nvim",
        module = "persistence",
        event = "BufReadPre",
        config = function()
            require("persistence").setup {
                dir = vim.fn.expand(vim.fn.stdpath "cache" .. "/sessions/"),
            }
        end,
    }
    use {
        "ahmedkhalf/project.nvim",
        event = "BufRead",
        ft = "alpha",
        config = function()
            require("project_nvim").setup {
                detection_methods = { "pattern", "lsp" },
                show_hidden = true, -- show hidden files in telescope
            }
        end,
    }
    use {
        "turbio/bracey.vim",
        opt = true,
        ft = "html",
        run = "npm install --prefix server",
    }
    use {
        "iamcco/markdown-preview.nvim",
        opt = true,
        ft = "markdown",
        run = function()
            vim.fn["mkdp#util#install"]()
        end,
    }
    use {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        config = "vim.g.undotree_WindowLayout = 2",
    }
    use {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        config = function()
            require("zen-mode").setup { plugins = { gitsigns = { enabled = true } } }
        end,
    }
    use {
        "norcalli/nvim-colorizer.lua",
        ft = { "html", "css", "javascript" },
        cmd = { "ColorizerToggle", "ColorizerAttachToBuffer" },
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

local fn, execute = vim.fn, vim.api.nvim_command
local install_path = DATA_PATH .. "/site/pack/packer/start/packer.nvim"

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

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
            config = function() require "plugins.lspconfig" end,
        },
    }
    -----------------------------------------------------------------------------//
    -- Completion and snippets {{{1
    -----------------------------------------------------------------------------//
    use {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        requires = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-path", after = "nvim-cmp" },
            { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
            { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
            { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
        },
        config = function() require "plugins.completion" end,
    }
    use {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
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
        branch = "0.1.x",
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
    use { "windwp/nvim-ts-autotag", event = "InsertEnter" }
    -----------------------------------------------------------------------------//
    -- Improve Editing and motions {{{1
    -----------------------------------------------------------------------------//
    use { "wellle/targets.vim" }
    use {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup {
                keymaps = {
                    insert = false,
                    insert_line = false,
                    normal = "sa",
                    normal_cur = "saa",
                    normal_line = false,
                    normal_cur_line = false,
                    visual = "s",
                    visual_line = false,
                    delete = "sd",
                    change = "sc",
                },
                highlight = {
                    duration = 0,
                },
            }
        end,
    }
    use {
        "phaazon/hop.nvim",
        config = function() require "plugins.hop" end,
    }
    use {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup {
                disable_filetype = { "TelescopePrompt", "vim" },
            }
        end,
    }
    use {
        "numToStr/Comment.nvim",
        keys = { "gcc", "gc", "gb" },
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
        config = function() require("plugins.git").gitsigns() end,
    }
    use {
        "TimUntersberger/neogit",
        cmd = "Neogit",
        config = function() require("plugins.git").neogit() end,
    }
    use {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        config = function() require("plugins.git").diffview() end,
    }
    -----------------------------------------------------------------------------//
    -- UI {{{1
    -----------------------------------------------------------------------------//
    use { "sainnhe/gruvbox-material" }
    use { "sainnhe/edge" }
    use { "projekt0n/github-nvim-theme" }
    use {
        "catppuccin/nvim",
        as = "catppuccin",
        config = function()
            require("catppuccin").setup {
                integrations = {
                    which_key = true,
                    neogit = true,
                    hop = true,
                },
            }
        end,
    }
    use {
        "goolord/alpha-nvim",
        config = function() require "plugins.alpha" end,
    }
    use {
        "nvim-lualine/lualine.nvim",
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
    }
    use {
        "stevearc/dressing.nvim",
        config = function()
            require("dressing").setup {
                input = {
                    insert_only = false,
                },
            }
        end,
    }
    use {
        "norcalli/nvim-colorizer.lua",
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
    --------------------------------------------------------------------------------
    -- Project and session management {{{1
    --------------------------------------------------------------------------------
    use { "kevinhwang91/nvim-bqf", ft = "qf" }
    use {
        "kyazdani42/nvim-tree.lua",
        requires = "nvim-web-devicons",
        config = function() require "plugins.tree" end,
    }
    use {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {
                detection_methods = { "pattern", "lsp" },
                show_hidden = true, -- show hidden files in telescope
            }
        end,
    }
    use {
        "Shatur/neovim-session-manager",
        config = function()
            require("session_manager").setup {
                autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
            }
        end,
    }
    -----------------------------------------------------------------------------//
    -- General plugins {{{1
    -----------------------------------------------------------------------------//
    use { "alker0/chezmoi.vim" }
    use {
        "mhartington/formatter.nvim",
        cmd = { "Format", "FormatWrite" },
        config = function() require "plugins.format" end,
    }
    use {
        "folke/which-key.nvim",
        module = "which-key",
        config = function() require "plugins.whichkey" end,
    }
    use {
        "mickael-menu/zk-nvim",
        config = function() require "plugins.zk" end,
    }
    use {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        config = function()
            vim.g.undotree_WindowLayout = 2
            vim.g.undotree_SplitWidth = 40
            vim.g.undotree_SetFocusWhenToggle = 1
            vim.g.undotree_ShortIndicators = 1
        end,
    }
end
-- }}}

local fn = vim.fn

local function load_plugins()
    local pack = require "packer"
    pack.init {
        snapshot_path = fn.stdpath "config" .. "/snapshots",
        git = { clone_timeout = 600 },
    }
    pack.startup {
        function() pack_use() end,
    }
end

local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    vim.cmd("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    load_plugins()
    require("packer").sync()
else
    load_plugins()
end
-- vim:foldmethod=marker

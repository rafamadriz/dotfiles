local pack_use = function()
    local use = require("packer").use
    use { "wbthomason/packer.nvim", branch = "fix/no-overwrite-commands" }
    -- use "dstein64/vim-startuptime"
    -----------------------------------------------------------------------------//
    -- Required by others
    -----------------------------------------------------------------------------//
    use { "nvim-lua/plenary.nvim", module = "plenary" }
    use { "nvim-lua/popup.nvim", module = "popup" }
    use {
        "kyazdani42/nvim-web-devicons",
        module = "nvim-web-devicons",
        config = function()
            require("nvim-web-devicons").setup { default = true }
        end,
    }
    -----------------------------------------------------------------------------//
    -- LSP, Autocomplete and snippets
    -----------------------------------------------------------------------------//
    use {
        "neovim/nvim-lspconfig",
        requires = "kabouzeid/nvim-lspinstall",
        config = function()
            require "lsp"
        end,
    }
    use {
        "hrsh7th/nvim-compe",
        event = "InsertEnter",
        config = function()
            require "plugins.completion"
        end,
    }
    use {
        { "rafamadriz/friendly-snippets", after = "vim-vsnip" },
        {
            "hrsh7th/vim-vsnip",
            event = "InsertEnter",
        },
    }
    use {
        "windwp/nvim-autopairs",
        after = "nvim-compe",
        config = function()
            if as._default(vim.g.neon_compe_autopairs) then
                require("nvim-autopairs").setup { check_ts = true }
                require("nvim-autopairs.completion.compe").setup {
                    map_cr = true, --  map <CR> on insert mode
                    map_complete = true, -- it will auto insert `(` after select function or method item
                }
            end
        end,
    }
    -----------------------------------------------------------------------------//
    -- Telescope
    -----------------------------------------------------------------------------//
    use {
        "nvim-telescope/telescope.nvim",
        wants = { "plenary.nvim", "popup.nvim", "telescope-fzf-native.nvim" },
        cmd = "Telescope",
        requires = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                opt = true,
                run = "make",
            },
        },
        config = function()
            require "plugins.telescope"
        end,
    }
    -----------------------------------------------------------------------------//
    -- Treesitter
    -----------------------------------------------------------------------------//
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        event = "BufRead",
        config = function()
            require "plugins.treesitter"
        end,
    }
    -----------------------------------------------------------------------------//
    -- Utils
    -----------------------------------------------------------------------------//
    use {
        "kyazdani42/nvim-tree.lua",
        wants = "nvim-web-devicons",
        cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
        config = function()
            require "plugins.tree"
        end,
    }
    use {
        "folke/which-key.nvim",
        config = function()
            require "plugins.which-key"
        end,
    }
    -----------------------------------------------------------------------------//
    -- Text Objects and Editing
    -----------------------------------------------------------------------------//
    use { "machakann/vim-sandwich", keys = { { "n", "s" }, { "v", "s" } } }
    use {
        "b3nj5m1n/kommentary",
        keys = { "gcc", "gc" },
        config = function()
            require("kommentary.config").configure_language("default", {
                prefer_single_line_comments = true,
            })
        end,
    }
    -----------------------------------------------------------------------------//
    -- Git
    -----------------------------------------------------------------------------//
    use {
        "sindrets/diffview.nvim",
        opt = true,
        after = "neogit",
        cmd = "DiffviewOpen",
        config = function()
            require("diffview").setup {
                key_bindings = {
                    disable_defaults = false, -- Disable the default key bindings
                    view = {
                        ["q"] = ":DiffviewClose<cr>",
                    },
                    file_panel = {
                        ["q"] = ":DiffviewClose<cr>",
                    },
                },
            }
        end,
    }
    use {
        "TimUntersberger/neogit",
        cmd = "Neogit",
        wants = { "plenary.nvim", "diffview.nvim" },
        config = function()
            require("neogit").setup {
                disable_context_highlighting = false,
                disable_commit_confirmation = true,
                integrations = { diffview = true },
                signs = {
                    -- { CLOSED, OPENED }
                    section = { "", "" },
                    item = { "", "" },
                    hunk = { "", "" },
                },
            }
        end,
    }
    use {
        "lewis6991/gitsigns.nvim",
        event = "BufRead",
        wants = "plenary.nvim",
        config = function()
            require("gitsigns").setup {
                signs = {
                    add = { hl = "GitSignsAdd", text = "┃" },
                    change = { hl = "GitSignsChange", text = "┃" },
                    delete = { hl = "GitSignsDelete", text = "契" },
                    topdelete = { hl = "GitSignsDelete", text = "契" },
                    changedelete = { hl = "GitSignsChange", text = "~" },
                },
                keymaps = {
                    noremap = true,
                    buffer = true,
                },
            }
        end,
    }
    use {
        "ruifm/gitlinker.nvim",
        opt = true,
        wants = "plenary.nvim",
        keys = { "<leader>gy" },
        config = function()
            require("gitlinker").setup()
        end,
    }
    -----------------------------------------------------------------------------//
    -- General plugins
    -----------------------------------------------------------------------------//
    use "rafamadriz/themes.nvim"
    use { "sbdchd/neoformat", event = "BufEnter" }
    use { "kevinhwang91/nvim-bqf", ft = "qf" }
    use {
        "mhinz/vim-startify",
        event = "VimEnter",
        config = function()
            require "plugins.startify"
        end,
    }
    use {
        "rafamadriz/statusline",
        config = function()
            require "plugins.statusline"
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
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPre",
        config = function()
            require "plugins.indent-guides"
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
            require("zen-mode").setup {
                plugins = {
                    gitsigns = { enabled = true },
                },
            }
        end,
    }
    use {
        "norcalli/nvim-colorizer.lua",
        event = "BufRead",
        config = function()
            require("colorizer").setup({ "*" }, {
                RRGGBBAA = true,
                rgb_fn = true,
                hsl_fn = true,
                css = true,
                css_fn = true,
            })
        end,
    }
    use {
        "akinsho/nvim-toggleterm.lua",
        keys = "<A-t>",
        cmd = "ToggleTerm",
        config = function()
            require("toggleterm").setup {
                size = 16,
                direction = "horizontal",
                open_mapping = [[<a-t>]],
            }
        end,
    }
end

local fn, execute = vim.fn, vim.api.nvim_command
local install_path = DATA_PATH .. "/site/pack/packer/start/packer.nvim"
local compile_path = install_path .. "/plugin/packer_compiled.lua"

local function load_plugins()
    local pack = require "packer"
    pack.init { compile_path = compile_path }
    pack.startup {
        function()
            pack_use()
        end,
    }
end

if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    load_plugins()
    require("packer").sync()
else
    load_plugins()
end

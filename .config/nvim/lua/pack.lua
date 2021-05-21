local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    execute "packadd packer.nvim"
end

return require("packer").startup(
    function()
        use "wbthomason/packer.nvim"

        -- LSP, Autocomplete and snippets
        use {
            "neovim/nvim-lspconfig",
            {"~/repos/friendly-snippets", after = "vim-vsnip"},
            {"hrsh7th/nvim-compe", opt = true, event = "InsertEnter *"},
            {"hrsh7th/vim-vsnip", opt = true, event = "InsertEnter *"},
            {"kabouzeid/nvim-lspinstall", cmd = {"LspInstall", "LspUninstall"}}
        }
        -- ====================================

        -- Telescope
        use {
            "nvim-telescope/telescope.nvim",
            requires = {
                "nvim-lua/popup.nvim",
                "nvim-lua/plenary.nvim",
                "nvim-telescope/telescope-fzy-native.nvim"
            }
        }
        -- ====================================

        -- Utils
        use {
            "tpope/vim-fugitive",
            "folke/which-key.nvim",
            "kevinhwang91/nvim-bqf",
            "machakann/vim-sandwich",
            "kyazdani42/nvim-tree.lua",
            {"b3nj5m1n/kommentary", keys = {"gcc", "gc"}}
        }
        -- ====================================

        -- General plugins
        use {
            "sbdchd/neoformat",
            "mhinz/vim-startify",
            "~/repos/statusline",
            "kyazdani42/nvim-web-devicons",
            {"windwp/nvim-autopairs", opt = true},
            {"nvim-treesitter/nvim-treesitter", opt = true, run = ":TSUpdate"},
            {"turbio/bracey.vim", opt = true, run = "npm install --prefix server"},
            {"iamcco/markdown-preview.nvim", opt = true, run = "cd app && yarn install"}
        }
        -- ====================================

        -- Themes
        use {
            "~/repos/neon",
            "rakr/vim-one",
            {"npxbr/gruvbox.nvim", requires = "rktjmp/lush.nvim"}
        }
        -- ====================================

        -- plugins with config
        use {
            "mbbill/undotree",
            cmd = "UndotreeToggle",
            config = "vim.g.undotree_WindowLayout = 2"
        }
        use {
            "folke/zen-mode.nvim",
            cmd = "ZenMode",
            config = require("zen-mode").setup {
                plugins = {
                    gitsigns = {enabled = true}
                }
            }
        }
        use {
            "norcalli/nvim-colorizer.lua",
            config = require "colorizer".setup(
                {"*"},
                {
                    RRGGBBAA = true,
                    rgb_fn = true,
                    hsl_fn = true,
                    css = true,
                    css_fn = true
                }
            )
        }
        use {
            "akinsho/nvim-toggleterm.lua",
            config = require "toggleterm".setup {
                size = 20,
                open_mapping = [[<a-t>]],
                shade_filetypes = {},
                shade_terminals = true,
                shading_factor = "1",
                start_in_insert = true,
                persist_size = true,
                direction = "horizontal"
            }
        }
        use {
            "lewis6991/gitsigns.nvim",
            config = require("gitsigns").setup {
                signs = {
                    add = {hl = "GitSignsAdd", text = "┃"},
                    change = {hl = "GitSignsChange", text = "┃"},
                    delete = {hl = "GitSignsDelete", text = "契"},
                    topdelete = {hl = "GitSignsDelete", text = "契"},
                    changedelete = {hl = "GitSignsChange", text = "~"}
                },
                numhl = false,
                linehl = false,
                keymaps = {
                    noremap = true,
                    buffer = true
                },
                watch_index = {
                    interval = 1000
                },
                sign_priority = 6,
                update_debounce = 200,
                status_formatter = nil,
                use_decoration_api = false
            }
        }
    end
)

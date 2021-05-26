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
        use "kabouzeid/nvim-lspinstall"
        use {"neovim/nvim-lspconfig", config = [[require("lsp")]]}
        use {"~/repos/friendly-snippets", after = "vim-vsnip"}
        use {
            "hrsh7th/nvim-compe",
            opt = true,
            event = "InsertEnter *",
            config = [[require("plugins.compe")]]
        }
        use {
            "hrsh7th/vim-vsnip",
            opt = true,
            event = "InsertEnter *",
            config = [[require("plugins.completion")]]
        }

        -- ====================================

        -- Telescope
        use {
            "nvim-telescope/telescope.nvim",
            requires = {
                "nvim-lua/popup.nvim",
                "nvim-lua/plenary.nvim",
                "nvim-telescope/telescope-fzy-native.nvim"
            },
            config = [[require("plugins.telescope")]]
        }
        -- ====================================

        -- Utils
        use {
            "tpope/vim-fugitive",
            "kevinhwang91/nvim-bqf",
            "machakann/vim-sandwich",
            {"b3nj5m1n/kommentary", keys = {"gcc", "gc"}},
            {"folke/which-key.nvim", config = [[require("plugins.which-key")]]},
            {"kyazdani42/nvim-tree.lua", config = [[require("plugins.nvim-tree")]]}
        }
        -- ====================================

        -- General plugins
        use {
            "sbdchd/neoformat",
            "kyazdani42/nvim-web-devicons",
            {"windwp/nvim-autopairs", opt = true},
            {"mhinz/vim-startify", config = [[require("plugins.startify")]]},
            {"~/repos/statusline", config = [[require("plugins.statusline")]]}
        }
        use {
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            config = [[require("plugins.treesitter")]]
        }
        use {
            "turbio/bracey.vim",
            opt = true,
            ft = "html",
            run = "npm install --prefix server"
        }
        use {
            "iamcco/markdown-preview.nvim",
            opt = true,
            ft = "markdown",
            run = "cd app && yarn install"
        }
        use {
            "lukas-reineke/indent-blankline.nvim",
            branch = "lua",
            config = [[require("plugins.indent-guides")]]
        }
        -- ====================================

        -- Themes
        use {
            "~/repos/neon",
            "rakr/vim-one",
            "~/repos/one",
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
            config = function()
                require("zen-mode").setup {
                    plugins = {
                        gitsigns = {enabled = true}
                    }
                }
            end
        }
        use {
            "norcalli/nvim-colorizer.lua",
            config = function()
                require "colorizer".setup(
                    {"*"},
                    {
                        RRGGBBAA = true,
                        rgb_fn = true,
                        hsl_fn = true,
                        css = true,
                        css_fn = true
                    }
                )
            end
        }
        use {
            "akinsho/nvim-toggleterm.lua",
            config = function()
                require "toggleterm".setup {
                    size = 20,
                    open_mapping = [[<a-t>]],
                    shade_filetypes = {},
                    shade_terminals = true,
                    shading_factor = "1",
                    start_in_insert = true,
                    persist_size = true,
                    direction = "horizontal"
                }
            end
        }
        use {
            "lewis6991/gitsigns.nvim",
            config = function()
                require("gitsigns").setup {
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
            end
        }
    end
)

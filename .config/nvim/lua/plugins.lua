return require("packer").startup(
    function()
        use "wbthomason/packer.nvim"

        -- LSP, Autocomplete and snippets
        use {
            "neovim/nvim-lspconfig",
            "glepnir/lspsaga.nvim",
            "hrsh7th/nvim-compe",
            "sbdchd/neoformat",
            "hrsh7th/vim-vsnip",
            "kabouzeid/nvim-lspinstall",
            "rafamadriz/friendly-snippets"
        }

        -- Telescope
        use {
            "nvim-telescope/telescope.nvim",
            requires = {
                {"nvim-lua/popup.nvim"},
                {"nvim-lua/plenary.nvim"},
                {"nvim-telescope/telescope-fzy-native.nvim"}
            }
        }

        -- Treesitter
        use {
            {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"},
            "p00f/nvim-ts-rainbow"
        }

        -- Git
        use "lewis6991/gitsigns.nvim"

        -- File manager
        use "kyazdani42/nvim-tree.lua"

        -- Markdown
        use {"iamcco/markdown-preview.nvim", run = "cd app && yarn install"}

        -- Statusline
        use "famiu/feline.nvim"

        -- Terminal
        use "akinsho/nvim-toggleterm.lua"

        -- General plugins
        use {
            "mbbill/undotree",
            "mhinz/vim-startify",
            "b3nj5m1n/kommentary",
            "folke/which-key.nvim",
            "windwp/nvim-autopairs",
            "norcalli/nvim-colorizer.lua",
            "blackCauldron7/surround.nvim",
            "kyazdani42/nvim-web-devicons",
            {"turbio/bracey.vim", run = "npm install --prefix server"}
        }

        -- Themes
        use {
            "rakr/vim-one",
            "rafamadriz/neon",
            "christianchiarulli/nvcode-color-schemes.vim",
            {"npxbr/gruvbox.nvim", requires = "rktjmp/lush.nvim"}
        }
    end
)

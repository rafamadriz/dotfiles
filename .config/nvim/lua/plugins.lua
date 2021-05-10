return require("packer").startup(
    function()
        use "wbthomason/packer.nvim"

        -- LSP, Autocomplete and snippets
        use {
            "neovim/nvim-lspconfig",
            "glepnir/lspsaga.nvim",
            "hrsh7th/nvim-compe",
            "hrsh7th/vim-vsnip",
            "kabouzeid/nvim-lspinstall",
            "~/repos/friendly-snippets"
        }
        -- ====================================

        -- Telescope
        use {
            "nvim-telescope/telescope.nvim",
            requires = {
                {"nvim-lua/popup.nvim"},
                {"nvim-lua/plenary.nvim"},
                {"nvim-telescope/telescope-fzy-native.nvim"}
            }
        }
        -- ====================================

        -- Treesitter
        use {
            {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"},
            "p00f/nvim-ts-rainbow"
        }
        -- ====================================

        -- Utils
        use {
            "mbbill/undotree",
            "b3nj5m1n/kommentary",
            "folke/which-key.nvim",
            "machakann/vim-sandwich",
            "kyazdani42/nvim-tree.lua",
            "akinsho/nvim-toggleterm.lua"
        }
        -- ====================================

        -- General plugins
        use {
            "sbdchd/neoformat",
            "famiu/feline.nvim",
            "mhinz/vim-startify",
            "windwp/nvim-autopairs",
            "norcalli/nvim-colorizer.lua",
            "kyazdani42/nvim-web-devicons",
            {"turbio/bracey.vim", run = "npm install --prefix server"},
            {"iamcco/markdown-preview.nvim", run = "cd app && yarn install"}
        }
        -- ====================================

        -- Git
        use "lewis6991/gitsigns.nvim"

        -- Themes
        use {
            "rakr/vim-one",
            "rafamadriz/neon",
            "christianchiarulli/nvcode-color-schemes.vim",
            {"npxbr/gruvbox.nvim", requires = "rktjmp/lush.nvim"}
        }
    end
)

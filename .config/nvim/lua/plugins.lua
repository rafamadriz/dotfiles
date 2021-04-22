return require("packer").startup(
    function()
        use "wbthomason/packer.nvim"

        -- LSP, Autocomplete and snippets
        use {
            "neovim/nvim-lspconfig",
            "hrsh7th/nvim-compe",
            "sbdchd/neoformat",
            "hrsh7th/vim-vsnip",
            "~/repos/friendly-snippets"
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
        use "glepnir/galaxyline.nvim"

        -- Terminal
        use {"akinsho/nvim-toggleterm.lua", "voldikss/vim-floaterm"}

        -- General plugins
        use {
            "kyazdani42/nvim-web-devicons",
            {"turbio/bracey.vim", run = "npm install --prefix server"},
            "mhinz/vim-startify",
            "mbbill/undotree",
            "b3nj5m1n/kommentary",
            "windwp/nvim-autopairs",
            "norcalli/nvim-colorizer.lua"
        }

        -- Themes
        use {
            "sainnhe/sonokai",
            "christianchiarulli/nvcode-color-schemes.vim",
            "sainnhe/edge",
            "Iron-E/nvim-highlite",
            {"Th3Whit3Wolf/onebuddy", requires = "tjdevries/colorbuddy.vim"},
            {"npxbr/gruvbox.nvim", requires = "rktjmp/lush.nvim"}
        }
    end
)

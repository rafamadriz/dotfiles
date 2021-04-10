return require("packer").startup(
    function()
        use "wbthomason/packer.nvim"

        -- LSP, Autocomplete and snippets
        use {
            "neovim/nvim-lspconfig",
            "hrsh7th/nvim-compe",
            "sbdchd/neoformat",
            "hrsh7th/vim-vsnip",
            "~/Repos/friendly-snippets"
        }

        -- Telescope
        use {
            "nvim-telescope/telescope.nvim",
            requires = {
                {"nvim-lua/popup.nvim"},
                {"nvim-lua/plenary.nvim"},
                {"nvim-telescope/telescope-media-files.nvim"}
            }
        }

        -- Treesitter
        use {
            {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"},
            "windwp/nvim-ts-autotag",
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
            "Th3Whit3Wolf/space-nvim",
            "sainnhe/edge",
            "Iron-E/nvim-highlite",
            {"Th3Whit3Wolf/onebuddy", requires = "tjdevries/colorbuddy.vim"},
            {"npxbr/gruvbox.nvim", requires = "rktjmp/lush.nvim"}
        }
    end
)

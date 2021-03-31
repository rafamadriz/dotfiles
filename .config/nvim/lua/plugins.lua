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
            "hrsh7th/nvim-compe",
            "sbdchd/neoformat",
            "onsails/lspkind-nvim",
            "hrsh7th/vim-vsnip",
            "mattn/emmet-vim",
            "rafamadriz/friendly-snippets"
        }

        -- Telescope
        use {
            "nvim-telescope/telescope.nvim",
            requires = {
                {"nvim-lua/popup.nvim"},
                {"nvim-lua/plenary.nvim"},
                {"nvim-telescope/telescope-fzy-native.nvim"},
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
        use {
            "kyazdani42/nvim-tree.lua",
            requires = {"kyazdani42/nvim-web-devicons"}
        }

        -- Markdown
        use {"iamcco/markdown-preview.nvim", run = "cd app && yarn install"}
        use "junegunn/goyo.vim"

        -- Statusline and bufferline
        use {"romgrk/barbar.nvim", "glepnir/galaxyline.nvim"}

        -- Terminal
        use {"akinsho/nvim-toggleterm.lua", "voldikss/vim-floaterm"}

        -- General plugins
        use {
            "mhinz/vim-startify",
            "mbbill/undotree",
            "b3nj5m1n/kommentary",
            "glepnir/indent-guides.nvim",
            "windwp/nvim-autopairs",
            "norcalli/nvim-colorizer.lua",
            "RRethy/vim-illuminate",
            "vim-scripts/loremipsum"
        }

        -- Themes
        use {
            "sainnhe/sonokai",
            "wadackel/vim-dogrun",
            "christianchiarulli/nvcode-color-schemes.vim",
            "Th3Whit3Wolf/one-nvim",
            "Th3Whit3Wolf/space-nvim",
            "sainnhe/edge",
            {"npxbr/gruvbox.nvim", requires = "rktjmp/lush.nvim"}
        }
    end
)

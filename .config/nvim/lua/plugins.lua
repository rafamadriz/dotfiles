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

        -- Autocomplete
        use {
            "neovim/nvim-lspconfig",
            requires = {
                {"hrsh7th/nvim-compe"},
                {"onsails/lspkind-nvim"},
                {"hrsh7th/vim-vsnip"}
            }
        }
        use "mattn/emmet-vim"
        use "capaj/vscode-standardjs-snippets"
        use "Wscats/html-snippets"
        use "cstrap/python-snippets"
        use "Harry-Ross/vscode-c-snippets"
        use "kitagry/vs-snippets"

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
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            requires = {"windwp/nvim-ts-autotag"}
        }

        -- File manager
        use {
            "kyazdani42/nvim-tree.lua",
            requires = {"kyazdani42/nvim-web-devicons"}
        }

        -- Statusline and bufferline
        use "romgrk/barbar.nvim"
        use "glepnir/galaxyline.nvim"

        -- Start screen
        use "mhinz/vim-startify"

        -- General plugins
        use "glepnir/indent-guides.nvim"
        use "sbdchd/neoformat"
        use "b3nj5m1n/kommentary"
        use "windwp/nvim-autopairs"
        use "norcalli/nvim-colorizer.lua"
        use "akinsho/nvim-toggleterm.lua"
        use "RRethy/vim-illuminate"
        use "p00f/nvim-ts-rainbow"
        use "vim-scripts/loremipsum"

        -- Themes
        use "sainnhe/sonokai"
        use "liuchengxu/space-vim-theme"
        use "christianchiarulli/nvcode-color-schemes.vim"
        use "gruvbox-community/gruvbox"
        use "Th3Whit3Wolf/one-nvim"
        use "sainnhe/edge"
        use "novakne/kosmikoa.nvim"
    end
)

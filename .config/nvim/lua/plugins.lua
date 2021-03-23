local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

return require('packer').startup(function()
  -- LSP
  use {
      'neovim/nvim-lspconfig',
      requires = {{'onsails/lspkind-nvim'}, {'hrsh7th/nvim-compe'}}
  }

  -- Treesitter
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  -- Nvim tree
  use {
      'kyazdani42/nvim-tree.lua',
      requires = {'kyazdani42/nvim-web-devicons'}
  }

  -- Statusline and bufferline
  use 'akinsho/nvim-bufferline.lua'
  use 'glepnir/galaxyline.nvim'

  -- Startify
  use 'mhinz/vim-startify'

  -- Indent guides
  use 'glepnir/indent-guides.nvim'

  -- Themes
  use 'sainnhe/sonokai'
  use 'glepnir/zephyr-nvim'
  use 'joshdick/onedark.vim'
  use 'liuchengxu/space-vim-theme'
  use 'christianchiarulli/nvcode-color-schemes.vim'
  use 'gruvbox-community/gruvbox'
end)

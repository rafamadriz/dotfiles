-- General settings
require('plugins')
require('themes')
require('settings')
require('mappings')

-- Plugins
require('plugins/treesitter')
require('plugins/nvim-tree')
require('plugins/bufferline')
require('plugins/statusline')
require('plugins/startify')
require('plugins/indent_guides')

-- LSP
<<<<<<< HEAD
require('lsp')
=======
require('lua')
require('lsp/lua')
>>>>>>> 285f6aed9b9109ded199a14ed668f1a3266b0490
require('lsp/completion')

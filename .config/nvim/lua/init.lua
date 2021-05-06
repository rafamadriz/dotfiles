-- General settings
require("config")
require("utils/handlers")
require("main/options")
require("main/mappings")
require("main/autocmds")
require("main/colorscheme")
require("plugins")

-- LSP
require("lsp")

-- Plugins
require("plugins/general")
require("plugins/completion")
require("plugins/which-key")
require("plugins/nvim-tree")
require("plugins/statusline")
require("plugins/startify")
require("plugins/telescope")
require("plugins/treesitter")

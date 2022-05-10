-- Override lspconfig's default border (or lack there of to use my own)
-- @source: https://github.com/akinsho/dotfiles/blob/main/.config/nvim/ftplugin/lspinfo.lua
-- @reference: https://github.com/neovim/nvim-lspconfig/issues/1717
vim.api.nvim_win_set_config(0, { border = as.lsp.borders })
-- This should be added by default to nvim-lspconfig
vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':close<CR>', { silent = true, desc = "close LspInfo window" })

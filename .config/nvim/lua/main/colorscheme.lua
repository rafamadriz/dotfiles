local cmd = vim.cmd

-- gruvbox
vim.g.gruvbox_italic = 1
vim.g.gruvbox_contrast_dark = "" .. CS

-- sonokai
vim.g.sonokai_style = "" .. CS
vim.g.sonokai_enable_italic = 1
vim.g.sonokai_better_performance = 1

-- spacevim
vim.g.space_vim_italic = 1

-- edge
vim.g.edge_style = "" .. CS
vim.g.edge_enable_italic = 1
vim.g.edge_better_performance = 1

-- Colorscheme
cmd("colorscheme " .. C)

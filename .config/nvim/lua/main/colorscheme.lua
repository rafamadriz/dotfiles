local cmd = vim.cmd

-- gruvbox
vim.g.gruvbox_italic = true
vim.g.gruvbox_contrast_dark = "" .. CS

-- one
vim.g.one_allow_italics = true

-- neon
vim.g.neon_italic_keyword = true
vim.g.neon_italic_boolean = true
vim.g.neon_bold = true

-- Colorscheme
cmd("colorscheme " .. C)

-- TODO: neon breaks if set before colorscheme, only in specific setups
vim.g.neon_style = "" .. CS

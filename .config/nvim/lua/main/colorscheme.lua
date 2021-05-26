local style = vim.g.neon_colorscheme_style or ""

-- gruvbox
vim.g.gruvbox_italic = true
vim.g.gruvbox_contrast_dark = "" .. style

-- one
vim.g.one_allow_italics = true

-- neon
vim.g.neon_italic_keyword = true
vim.g.neon_italic_boolean = true
vim.g.neon_bold = true
vim.g.neon_style = "" .. style

-- Colorscheme
vim.cmd("colorscheme " .. as.select_theme(vim.g.neon_colorscheme))

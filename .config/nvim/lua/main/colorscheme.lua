local style = vim.g.neon_colorscheme_style or ""

-- gruvbox
vim.g.gruvbox_italic_keyword = true
vim.g.gruvbox_italic_boolean = true
vim.g.gruvbox_bold = true
vim.g.gruvbox_style = "" .. style

-- neon
vim.g.neon_italic_keyword = true
vim.g.neon_italic_boolean = true
vim.g.neon_bold = true
vim.g.neon_style = "" .. style

-- onepro
vim.g.onepro_italic_keyword = true
vim.g.onepro_italic_boolean = true
vim.g.onepro_bold = true

-- Colorscheme
vim.cmd("colorscheme " .. as.select_theme(vim.g.neon_colorscheme))

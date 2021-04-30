local cmd = vim.cmd

-- gruvbox
vim.g.gruvbox_italic = 1
vim.g.gruvbox_contrast_dark = "" .. CS

-- material
vim.g.material_style = "" .. CS
vim.g.material_italic_comments = true
vim.g.material_italic_keywords = true
vim.g.material_italic_functions = true
vim.g.material_italic_variables = false
vim.g.material_contrast = true
vim.g.material_borders = false
vim.g.material_disable_background = false

-- Colorscheme
cmd("colorscheme " .. C)

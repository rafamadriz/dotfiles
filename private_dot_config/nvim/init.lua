require "globals"
require "settings"
require "plugins"

vim.g.edge_better_performance = 1
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_palette = "material" -- material, mix & original

local colorscheme = "kanagawa"

for _, key in pairs(vim.fn.getcompletion("", "color")) do
    if colorscheme == key then vim.cmd.colorscheme(colorscheme) end
end

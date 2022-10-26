local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/impatient/start/impatient.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    -- NOTE: this is plugin is unnecessary once https://github.com/neovim/neovim/pull/15436 is merged
    fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/lewis6991/impatient.nvim",
        install_path,
    }
end

require "impatient"
require "globals"
require "settings"
require "plugins"

vim.g.edge_better_performance = 1
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_palette = "material" -- material, mix & original

local colorscheme = "github_dark_default"

for _, key in pairs(fn.getcompletion("", "color")) do
    if colorscheme == key then vim.cmd.colorscheme(colorscheme) end
end

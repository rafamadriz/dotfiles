local install_path = vim.fn.stdpath "data" .. "/site/pack/impatient/start/impatient.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    -- NOTE: this is plugin is unnecessary once https://github.com/neovim/neovim/pull/15436 is merged
    vim.fn.system {
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

vim.cmd "colorscheme github_dark_default"

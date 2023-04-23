-- To choose a colorscheme just delete (dd) lazy = false from current
-- colorscheme and move/paste (p) it to desired one
return {
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        config = function()
            require("kanagawa").setup {
                compile = true, -- enable compiling the colorscheme
                dimInactive = true, -- dim inactive window `:h hl-NormalNC`
                theme = "wave", -- options: wave, dragon, lotus
                background = {
                    dark = "dragon",
                    light = "lotus",
                },
            }
            vim.cmd.colorscheme "kanagawa"
        end,
    },
    {
        "sainnhe/edge",
        config = function()
            vim.g.edge_dim_inactive_windows = 1
            vim.g.edge_style = "aura" -- options: default , aura , neon
            vim.g.edge_better_performance = 1
            vim.cmd.colorscheme "edge"
        end,
    },
    {
        "sainnhe/gruvbox-material",
        config = function()
            vim.g.gruvbox_material_dim_inactive_windows = 1
            vim.g.gruvbox_material_better_performance = 1
            vim.g.gruvbox_material_foreground = "material" -- options: material, mix, original
            vim.g.gruvbox_material_background = "medium" -- options: hard, medium, soft
            vim.cmd.colorscheme "gruvbox-material"
        end,
    },
    {
        "projekt0n/github-nvim-theme",
        version = "*",
        config = function() require("github-theme").setup() end,
    },
}

-- To choose a colorscheme just delete (dd) lazy = false from current
-- colorscheme and move/paste (p) it to desired one
return {
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").setup {
                compile = true, -- enable compiling the colorscheme
                dimInactive = true, -- dim inactive window `:h hl-NormalNC`
                theme = "wave", -- options: wave, dragon, lotus
                background = {
                    dark = "wave",
                    light = "lotus",
                },
            }
            vim.cmd.colorscheme "kanagawa"
            vim.api.nvim_set_hl(0, "CurSearch", { fg = "#223249", bg = "#ff9e3b" })
        end,
    },
    {
        "sainnhe/gruvbox-material",
        config = function()
            vim.g.gruvbox_material_dim_inactive_windows = 1
            vim.g.gruvbox_material_better_performance = 1
            vim.g.gruvbox_material_foreground = "original" -- options: material, mix, original
            vim.g.gruvbox_material_background = "medium" -- options: hard, medium, soft
            vim.cmd.colorscheme "gruvbox-material"
        end,
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        config = function()
            require("tokyonight").setup {
                style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
                sidebars = { "qf", "help", "neo-tree", "undotree" },
                dim_inactive = true,
                lualine_bold = true,
            }
            vim.cmd.colorscheme "tokyonight"
        end,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require("rose-pine").setup {
                --- @usage 'main'|'moon'|'dawn'
                dark_variant = "main",
                dim_nc_background = true,
            }
            vim.cmd "colorscheme rose-pine"
        end,
    },
}

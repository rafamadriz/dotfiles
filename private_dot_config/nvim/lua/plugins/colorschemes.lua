-- To choose a colorscheme just delete (dd) lazy = false from current
-- colorscheme and move/paste (p) it to desired one
---@module "lazy"
---@type LazySpec
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
    {
        "catppuccin/nvim",
        lazy = false,
        name = "catppuccin",
        config = function()
            require("catppuccin").setup {
                dim_inactive = {
                    enabled = true,
                    shade = "dark",
                    percentage = 0.15,
                },
            }
            vim.cmd.colorscheme "catppuccin"
        end,
    },
    {
        "oonamo/ef-themes.nvim",
        config = function()
            require("ef-themes").setup {
                light = "ef-spring", -- Ef-theme to select for light backgrounds
                dark = "ef-maris-dark",
                -- transparent = true,
                modules = {
                    blink = true,
                    cmp = true,
                    fzf = true,
                    gitsigns = true,
                    mini = true,
                    neogit = true,
                    render_markdown = true,
                    semantic_tokens = true,
                    snacks = true,
                    telescope = true,
                    treesitter = true,
                    which_key = true,
                },
            }
            vim.cmd.colorscheme "ef-theme"
        end,
    },
}

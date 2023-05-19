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
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            require("catppuccin").setup {
                dim_inactive = {
                    enabled = true,
                    shade = "dark",
                    percentage = 0.15,
                },
                integrations = {
                    cmp = true,
                    dashboard = true,
                    gitsigns = true,
                    harpoon = false,
                    leap = true,
                    lsp_trouble = false,
                    markdown = true,
                    mason = true,
                    mini = true,
                    neotree = true,
                    overseer = false,
                    telescope = true,
                    treesitter = true,
                    treesitter_context = true,
                    which_key = true,
                    dap = {
                        enabled = false,
                        enable_ui = false,
                    },
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = { "italic" },
                            hints = { "italic" },
                            warnings = { "italic" },
                            information = { "italic" },
                        },
                        underlines = {
                            errors = { "underline" },
                            hints = { "underline" },
                            warnings = { "underline" },
                            information = { "underline" },
                        },
                    },
                },
            }
            vim.cmd.colorscheme "catppuccin"
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
        lazy = false,
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

-- To choose a colorscheme just delete (dd) lazy = false from current
-- colorscheme and move/paste (p) it to desired one
---@module "lazy"
---@type LazySpec
return {
    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        config = function()
            vim.cmd.colorscheme "carbonfox"
        end
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
            }
            vim.cmd.colorscheme "catppuccin"
        end,
    },
}

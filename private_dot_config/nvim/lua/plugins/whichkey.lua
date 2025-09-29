---@module "lazy"
---@type LazySpec
return {
    "folke/which-key.nvim",
    lazy = false,
    enabled = false,
    opts = {
        preset = "helix",
        icons = { mappings = false, keys = { Space = "SPC" } },
        spec = {
            {
                mode = { "n", "v" }, -- NORMAL and VISUAL mode
                { "<leader>b", group = "Buffer" },
                { "<leader>d", group = "Debug" },
                { "<leader>f", group = "Find" },
                { "<leader>g", group = "Git" },
                { "<leader>gy", group = "Link" },
                { "<leader>l", group = "LSP" },
                { "<leader>t", group = "Tasks" },
            },
        },
    },
}

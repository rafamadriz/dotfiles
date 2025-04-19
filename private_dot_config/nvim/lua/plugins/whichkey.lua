---@module "lazy"
---@type LazySpec
return {
    "folke/which-key.nvim",
    lazy = false,
    opts = {
        preset = "helix",
        icons = { mappings = false, keys = { Space = "SPC" } },
        spec = {
            {
                mode = { "n", "v" }, -- NORMAL and VISUAL mode
                { "<leader>1", hidden = true },
                { "<leader>2", hidden = true },
                { "<leader>3", hidden = true },
                { "<leader>4", hidden = true },
                { "<leader>a", hidden = true },
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

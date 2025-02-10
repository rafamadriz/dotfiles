return {
    {
        "stevearc/dressing.nvim",
        lazy = false,
        config = function()
            require("dressing").setup {
                input = {
                    insert_only = false,
                },
            }
        end,
    },
    {
        "uga-rosa/ccc.nvim",
        ft = { "typescript", "typescriptreact", "javascriptreact", "html", "css" },
        cmd = { "CccPick", "CccHighlighterToggle" },
        opts = { highlighter = { auto_enable = true } },
    },
}

require("nvim-treesitter.configs").setup {
    ensure_installed = "all",
    highlight = {
        enable = true,
        disable = { "html" },
    },
    indent = { enable = false },
    autopairs = { enable = true },
    autotag = { enable = true },
}

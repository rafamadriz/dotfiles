return {
    {
        "glepnir/dashboard-nvim",
        event = "VimEnter",
        config = function()
            require("dashboard").setup {
                theme = "hyper",
                config = {
                    week_header = { enable = true },
                    shortcut = {
                        { desc = "Plugins", action = "Lazy", key = "l" },
                        { desc = "Find files", action = "Telescope find_files", key = "f" },
                        { desc = "Grep string", action = "Telescope live_grep_args", key = "g" },
                        {
                            desc = "Dotfiles",
                            action = "Telescope find_files cwd=~/.local/share/chezmoi/",
                            key = "d",
                        },
                        { desc = "Quit", action = "quitall", key = "q" },
                    },
                },
            }
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            require("lualine").setup {
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "" },
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = { "diagnostics", "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                extensions = { "quickfix" },
            }
        end,
    },
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

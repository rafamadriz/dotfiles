return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        lazy = false,
        keys = {
            { "<leader>e", "<cmd>Neotree toggle right filesystem<CR>", desc = "Toggle file tree" },
            { "<leader>lo", "<cmd>Neotree toggle right document_symbols<CR>", desc = "Toggle symbols outline" },
        },
        config = function()
            require("neo-tree").setup {
                close_if_last_window = true,
                source_selector = {
                    winbar = true,
                },
                sources = {
                    "filesystem",
                    "buffers",
                    "git_status",
                    "document_symbols",
                },
                window = {
                    position = "right",
                    mappings = {
                        ["{"] = { "prev_source" },
                        ["}"] = { "next_source" },
                        ["<tab>"] = { "toggle_node", nowait = false },
                        ["/"] = "none",
                        ["<space>"] = "none",
                    },
                },
                default_component_configs = {
                    name = {
                        trailing_slash = true,
                    },
                },
                filesystem = {
                    filtered_items = {
                        hide_dotfiles = false,
                        hide_gitignored = false,
                        hide_by_name = {
                            --"node_modules"
                        },
                        hide_by_pattern = { -- uses glob style patterns
                            --"*.meta",
                            --"*/src/*/tsconfig.json",
                        },
                        always_show = { -- remains visible even if other settings would normally hide it
                            --".gitignored",
                        },
                        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                            --".DS_Store",
                            --"thumbs.db"
                        },
                        never_show_by_pattern = { -- uses glob style patterns
                            --".null-ls_*",
                        },
                    },
                    follow_current_file = true,
                    use_libuv_file_watcher = true,
                },
            }
        end,
        dependencies = { "MunifTanjim/nui.nvim" },
    },
}

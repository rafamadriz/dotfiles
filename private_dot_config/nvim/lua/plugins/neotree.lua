return {
     {
         "nvim-neo-tree/neo-tree.nvim",
	 lazy = false,
         keys = { {"<leader>e", "<cmd>Neotree toggle<CR>", desc = "Open file tree"}},
         config = function()
            require("neo-tree").setup {
                window = {
                    position = "right",
                    mappings = {
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
                },
            }
         end,
         dependencies = { "MunifTanjim/nui.nvim" },
     },
}

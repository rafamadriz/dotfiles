require("nvim-tree").setup {
    disable_netrw = true, -- disables netrw completely
    update_cwd = true, -- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
    sync_root_with_cwd = true, -- Changes the tree root directory on `DirChanged` and refreshes the tree.
    update_focused_file = {
        enable = true,
        update_cwd = false,
    },
    view = {
        width = 40,
        side = "right",
        mappings = {
            list = {
                { key = "S", action = "" },
                { key = "?", action = "toggle_help" },
            },
        },
    },
    renderer = {
        add_trailing = true,
        highlight_git = true,
        group_empty = true,
        highlight_opened_files = "all",
        indent_markers = {
            enable = true,
        },
        icons = {
            git_placement = "after",
        },
    },
    diagnostics = {
        enable = true,
    },
}

require 'nvim-tree'.setup {
    disable_netrw = true, -- disables netrw completely
    update_cwd = true, -- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
    view = {
        width = 40,
        side = "right",
        mappings = {
            list = {
                { key = "?", action = "toggle_help" },
            },
        },
    },
    renderer = {
        icons = {
            git_placement = "after",
        }
    },
    diagnostics = {
        enable = true,
    },
}

vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_group_empty = 1

as.nnoremap('<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Open file tree' })
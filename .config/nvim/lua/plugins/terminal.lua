require "toggleterm".setup {
    size = 20,
    open_mapping = [[<c-a-t>]],
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = "1", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    persist_size = true,
    direction = "horizontal"
}

-- Floaterm
vim.g.floaterm_keymap_toggle = "<F1>"
vim.g.floaterm_keymap_next = "<F2>"
vim.g.floaterm_keymap_prev = "<F3>"
vim.g.floaterm_keymap_new = "<F4>"
vim.g.floaterm_title = ""

vim.g.floaterm_gitcommit = "floaterm"
vim.g.floaterm_autoinsert = 1
vim.g.floaterm_width = 0.8
vim.g.floaterm_height = 0.8
vim.g.floaterm_wintitle = 0
vim.g.floaterm_autoclose = 1
vim.g.floaterm_opener = "edit"

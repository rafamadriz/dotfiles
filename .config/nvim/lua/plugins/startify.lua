vim.g.header_ascii = {
    "     ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "     ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "     ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "     ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "     ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "     ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ "
}

vim.api.nvim_exec(
    "let startify_lists = [ { 'type': 'files',     'header': ['   Files'] }, { 'type': 'sessions',  'header': ['   Sessions'] },    { 'type': 'bookmarks', 'header': ['   Bookmarks'] },                                                                   ]",
    true
)

vim.api.nvim_exec(
    "let startify_bookmarks = [ { 'i': '~/.config/nvim/init.lua' }, {'c': '~/.config/nvim/lua/config.lua'}, { 'p': '~/.config/nvim/lua/pack.lua' }, { 'z': '~/.config/zsh/.zshrc' }, { 'E': '~/.zshenv' }]",
    true
)

vim.g.startify_session_dir = vim.fn.stdpath("data") .. "/startify_session"

-- start Vim in a directory that contains a Session.vim, that session will be loaded automatically
vim.g.startify_session_autoload = 1
-- Let Startify take care of buffers
vim.g.startify_session_delete_buffers = 1
-- Similar to Vim-rooter
vim.g.startify_change_to_vcs_root = 1
-- Unicode
vim.g.startify_fortune_use_unicode = 1
-- Automatically update sessions
vim.g.startify_session_persistence = 1
-- Get rid of empy buffer on quit
vim.g.startify_enable_special = 0
-- The number of files to list.
vim.g.startify_files_number = 16
-- The number of spaces used for left padding.
vim.g.startify_padding_left = 6
-- Header
vim.g.startify_custom_header = "startify#center(g:header_ascii)"

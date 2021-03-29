vim.g.header_ascii = {
    "     ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "     ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "     ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "     ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "     ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "     ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ "
}

--vim.g.startify_bookmarks = {
--             { 'i': '~/.config/nvim/init.vim' },
--             { 'p': '~/Documents/Programming/' },
--             { 'z': '~/.config/zsh/.zshrc' },
--             { 't': '~/.config/kitty/kitty.conf' },
--             }
--
--vim.g.startify_lists = {
--           { 'type': 'files',     'header': ['   Files']                        },
--           { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
--           { 'type': 'sessions',  'header': ['   Sessions']                     },
--           { 'type': 'bookmarks', 'header': ['   Bookmarks']                    },
--           }

vim.api.nvim_exec(
    "let startify_lists = [ { 'type': 'files',     'header': ['   Files'] }, { 'type': 'dir',     'header': ['   Current Directory '.getcwd()] }, { 'type': 'sessions',  'header': ['   Sessions'] },    { 'type': 'bookmarks', 'header': ['   Bookmarks'] },                                                                   ]",
    true
)

vim.api.nvim_exec(
    "let startify_bookmarks = [ { 'i': '~/.config/nvim/init.lua' }, {'c': '~/.config/nvim/lua/config.lua'}, { 'z': '~/.config/zsh/.zshrc' } ]",
    true
)

vim.g.startify_session_dir = "~/.config/nvim/session"

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
vim.g.startify_custom_header = "startify#center(g:header_ascii)"

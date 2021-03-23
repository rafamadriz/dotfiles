"let g:startify_custom_header = [
        "\ '        _   ___    ________          __   ',
        "\ '       / | / / |  / / ____/___  ____/ /__ ',
        "\ '      /  |/ /| | / / /   / __ \/ __  / _ \',
        "\ '     / /|  / | |/ / /___/ /_/ / /_/ /  __/',
        "\ '    /_/ |_/  |___/\____/\____/\__,_/\___/ ',
        "\]

"let g:header_ascii = [
        "\'    __    __                     __     __  __                ',
        "\'    |  \  |  \                   |  \   |  \|  \               ',
        "\'    | $$\ | $$  ______    ______ | $$   | $$ \$$ ______ ____   ',
        "\'    | $$$\| $$ /      \  /      \| $$   | $$|  \|      \    \  ',
        "\'    | $$$$\ $$|  $$$$$$\|  $$$$$$\\$$\ /  $$| $$| $$$$$$\$$$$\ ',
        "\'    | $$\$$ $$| $$    $$| $$  | $$ \$$\  $$ | $$| $$ | $$ | $$ ',
        "\'    | $$ \$$$$| $$$$$$$$| $$__/ $$  \$$ $$  | $$| $$ | $$ | $$ ',
        "\'    | $$  \$$$ \$$     \ \$$    $$   \$$$   | $$| $$ | $$ | $$ ',
        "\'    \ $$   \$$  \$$$$$$$  \$$$$$$     \$     \$$ \$$  \$$  \$$ ',
  "\]

let g:header_ascii = [
         \'     ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
         \'     ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
         \'     ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
         \'     ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
         \'     ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
         \'     ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
\]

let g:startify_bookmarks = [
            \ { 'i': '~/.config/nvim/init.vim' },
            \ { 'p': '~/Documents/Programming/' },
            \ { 'z': '~/.config/zsh/.zshrc' },
            \ { 't': '~/.config/kitty/kitty.conf' },
            \ ]

let g:startify_lists = [
          \ { 'type': 'files',     'header': ['   Files']                        },
          \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
          \ { 'type': 'sessions',  'header': ['   Sessions']                     },
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']                    },
          \ ]

let g:startify_session_dir = '~/.config/nvim/session'

"start Vim in a directory that contains a Session.vim, that session will be loaded automatically
let g:startify_session_autoload = 1
" Let Startify take care of buffers
let g:startify_session_delete_buffers = 1
" Similar to Vim-rooter
let g:startify_change_to_vcs_root = 1
" Unicode
let g:startify_fortune_use_unicode = 1
" Automatically update sessions
let g:startify_session_persistence = 1
" Get rid of empy buffer on quit
let g:startify_enable_special = 0
let g:startify_custom_header = startify#center(g:header_ascii)

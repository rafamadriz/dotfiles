"
"    ██████╗  █████╗ ███████╗ █████╗     ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
"    ██╔══██╗██╔══██╗██╔════╝██╔══██╗    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
"    ██████╔╝███████║█████╗  ███████║    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
"    ██╔══██╗██╔══██║██╔══╝  ██╔══██║    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
"    ██║  ██║██║  ██║██║     ██║  ██║    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
"    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
"

"""""""""""""""""""""""""""""""""""""""""""
"----------  General Settings  -----------"
"""""""""""""""""""""""""""""""""""""""""""
syntax on
filetype plugin on
set path+=**
set wildmenu
set clipboard+=unnamedplus
set cursorline
set showcmd
set mouse=a
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set nohlsearch
set hidden
set numberwidth=5
set relativenumber
set backspace=indent,eol,start
set smartcase
set ignorecase
set noswapfile
set nobackup
set undodir=~/.config/nvim/undodir
set undofile
set updatetime=50
set incsearch
set termguicolors
set scrolloff=10
set autoindent
set background=dark
set encoding=UTF-8
set noshowmode

" Load first
source $HOME/.config/nvim/plug-config/polyglot.vim

" jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" EJS
au BufNewFile,BufRead *.ejs set filetype=html

"Markdown
au BufNewFile,BufRead *.md set conceallevel=0

"""""""""""""""""""""""""""""""""""""
"------------  Vim Plug  -----------"
"""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

" Start screen
Plug 'mhinz/vim-startify'

" Themes
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'morhetz/gruvbox'
Plug 'sainnhe/gruvbox-material'
Plug 'sainnhe/sonokai'
Plug 'phanviet/vim-monokai-pro'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'joshdick/onedark.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline-themes'

" IDE
Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/syntastic'
Plug 'easymotion/vim-easymotion'
Plug 'sheerun/vim-polyglot'
Plug 'yggdroot/indentline'
Plug 'preservim/nerdcommenter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mattn/emmet-vim'
Plug 'ap/vim-css-color'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

call plug#end()

"""""""""""""""""""""""""""""""""""
"-----------  Themes  ------------"
"""""""""""""""""""""""""""""""""""
"let g:material_theme_style = 'palenight'
colorscheme sonokai

" Transparency
"hi! Normal ctermbg=NONE guibg=NONE
"hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"---------------  Keybindings Configuration  -----------------"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source $HOME/.config/nvim/keys/mappings.vim
source $HOME/.config/nvim/keys/autocm.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""
"-------------  Plugin Configuration  --------------"
"""""""""""""""""""""""""""""""""""""""""""""""""""""
source $HOME/.config/nvim/plug-config/start-screen.vim
source $HOME/.config/nvim/plug-config/nerdtree.vim
source $HOME/.config/nvim/plug-config/easymotion.vim
source $HOME/.config/nvim/plug-config/neoclide-coc.vim
source $HOME/.config/nvim/plug-config/emmet.vim
source $HOME/.config/nvim/plug-config/indentLine.vim
source $HOME/.config/nvim/plug-config/fzf.vim
source $HOME/.config/nvim/plug-config/arline.vim

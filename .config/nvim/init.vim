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
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent smartindent
set incsearch ignorecase smartcase nohlsearch
set numberwidth=1 relativenumber nu title
set backspace=indent,eol,start
set noswapfile nobackup undofile
set undodir=~/.config/nvim/undodir
set showcmd noshowmode
set clipboard+=unnamedplus
set updatetime=50
set scrolloff=10
set background=dark
set termguicolors
set encoding=UTF-8
set path+=**
set nowrap
set wildmenu
set cursorline
set mouse=a
set hidden
set splitbelow
filetype plugin on
syntax on

" Load first
source $HOME/.config/nvim/plug-config/polyglot.vim

"""""""""""""""""""""""""""""""""""""
"------------  Vim Plug  -----------"
"""""""""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugged')

" Start screen
Plug 'mhinz/vim-startify'

" Themes
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'arcticicestudio/nord-vim'
Plug 'b4skyx/serenade'
Plug 'sainnhe/forest-night'
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
Plug 'vimlab/split-term.vim'
Plug 'scrooloose/syntastic'
Plug 'sheerun/vim-polyglot'
Plug 'nathanaelkane/vim-indent-guides'
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
colorscheme onedark
highlight Comment gui=italic
" Transparency
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"---------------  Keybindings Configuration  -----------------"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source $HOME/.config/nvim/keys/mappings.vim
source $HOME/.config/nvim/keys/autocm.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""
"-------------  Plugin Configuration  --------------"
"""""""""""""""""""""""""""""""""""""""""""""""""""""
source $HOME/.config/nvim/plug-config/themes.vim
source $HOME/.config/nvim/plug-config/start-screen.vim
source $HOME/.config/nvim/plug-config/nerdtree.vim
source $HOME/.config/nvim/plug-config/easymotion.vim
source $HOME/.config/nvim/plug-config/neoclide-coc.vim
source $HOME/.config/nvim/plug-config/emmet.vim
source $HOME/.config/nvim/plug-config/indent-guides.vim
source $HOME/.config/nvim/plug-config/fzf.vim
source $HOME/.config/nvim/plug-config/arline.vim

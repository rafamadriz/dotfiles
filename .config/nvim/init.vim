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
set numberwidth=1
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
colorscheme forest-night

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
source $HOME/.config/nvim/plug-config/themes.vim
source $HOME/.config/nvim/plug-config/start-screen.vim
source $HOME/.config/nvim/plug-config/nerdtree.vim
source $HOME/.config/nvim/plug-config/easymotion.vim
source $HOME/.config/nvim/plug-config/neoclide-coc.vim
source $HOME/.config/nvim/plug-config/emmet.vim
source $HOME/.config/nvim/plug-config/indent-guides.vim
source $HOME/.config/nvim/plug-config/fzf.vim
source $HOME/.config/nvim/plug-config/arline.vim

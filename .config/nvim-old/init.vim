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
set clipboard+=unnamedplus
set showcmd noshowmode
set background=dark
set showtabline=2
set shortmess+=c
set updatetime=50
set scrolloff=10
set cmdheight=2
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
Plug 'b4skyx/serenade'
Plug 'sainnhe/forest-night'
Plug 'sainnhe/gruvbox-material'
Plug 'liuchengxu/space-vim-theme'
Plug 'Th3Whit3Wolf/space-nvim'
Plug 'sainnhe/sonokai'
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
Plug 'ap/vim-css-color'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'junegunn/goyo.vim'

call plug#end()

"""""""""""""""""""""""""""""""""""
"-----------  Themes  ------------"
"""""""""""""""""""""""""""""""""""
source $HOME/.config/nvim/plug-config/themes.vim
colorscheme space_vim_theme
highlight Comment gui=italic
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
source $HOME/.config/nvim/plug-config/neoclide-coc.vim
source $HOME/.config/nvim/plug-config/indent-guides.vim
source $HOME/.config/nvim/plug-config/fzf.vim
source $HOME/.config/nvim/plug-config/airline.vim
source $HOME/.config/nvim/plug-config/treesitter.vim

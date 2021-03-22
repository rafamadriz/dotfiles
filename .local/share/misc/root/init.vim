""""""""""""""""""""""
"  General Settings  "
""""""""""""""""""""""
syntax on
filetype plugin on
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent smartindent
set incsearch ignorecase smartcase nohlsearch
set numberwidth=1 relativenumber nu title
set viminfo+=n$HOME/.config/nvim/viminfo
set completeopt=menuone,longest,noselect
set omnifunc=syntaxcomplete#Complete
set undodir=~/.config/nvim/undodir
set noswapfile nobackup undofile
set backspace=indent,eol,start
set clipboard+=unnamedplus
set showcmd noshowmode
set complete+=kspell
set updatetime=50
set scrolloff=10
set termguicolors
set encoding=UTF-8
set noerrorbells
set shortmess+=c
set path+=**
set nowrap
set showmatch
set wildmenu
set cursorline
set nocompatible
set mouse=a
set hidden
set splitbelow

" jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

colorscheme tender
highlight Comment gui=italic

""""""""""""""""
"  Statusline  "
""""""""""""""""
set laststatus=2
set statusline=
let g:currentmode={
       \ 'n'  : 'NORMAL ',
       \ 'v'  : 'VISUAL ',
       \ 'V'  : 'V·Line ',
       \ '' : 'V·Block ',
       \ 'i'  : 'INSERT ',
       \ 'R'  : 'R ',
       \ 'Rv' : 'V·Replace ',
       \ 'c'  : 'Command ',
       \}
set statusline+=%1*\ %{toupper(g:currentmode[mode()])}
set statusline+=%#PmenuSel#
set statusline+=%2*\ %f
set statusline+=%m
set statusline+=%=
set statusline+=%y
set statusline+=%3*\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=%3*\[%{&fileformat}\]\ |
set statusline+=%4*\ %p%%
set statusline+=%4*\ %l/%L
set statusline+=%4*\ col:%c\ |

hi user1 guifg=#1d1d1d ctermfg=234 guibg=#666666 ctermbg=242 gui=Bold cterm=Bold
hi user2 guifg=#999999 ctermfg=246 guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
hi user3 guifg=NONE ctermfg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
hi user4 guifg=#c9d05c ctermfg=185 guibg=NONE ctermbg=NONE gui=Bold cterm=Bold

hi PMenu guifg=#dadada ctermfg=253 guibg=#335261 ctermbg=239 gui=NONE cterm=NONE
hi PMenuSel guifg=#335261 ctermfg=239 guibg=#c9d05c ctermbg=185 gui=NONE cterm=NONE
hi PmenuSbar guifg=#335261 ctermfg=239 guibg=#335261 ctermbg=239 gui=NONE cterm=NONE
hi PmenuThumb guifg=#c9d05c ctermfg=185 guibg=#c9d05c ctermbg=185 gui=NONE cterm=NONE

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi User1 guibg=White ctermfg=6 guifg=Black ctermbg=0
  else
    hi User1 guibg=DarkRed ctermfg=1 guifg=Black ctermbg=0
  endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi User1 guibg=#778c82 ctermfg=8 guifg=Black ctermbg=15

"""""""""""""""""""""""
"  Autocomplete Menu  "
"""""""""""""""""""""""
set omnifunc=htmlcomplete#CompleteTags
set omnifunc=csscomplete#CompleteCSS

inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Trim any trailing white space
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup MYVIMRC
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
augroup END

" Tweaks for browsing files
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

let mapleader = " "

"--------------------- Useful Commands -------------------
" AUTOCOMPLETE
" - ^n - autocomplete suggestions (next)
" - ^p - autocomplete suggestions (previous)
" - ^x^f - for filenames
" - ^x^] - tags only

inoremap jk <ESC>
inoremap kj <ESC>
nnoremap Q <Nop>
nmap <leader>w :w<CR>
nmap <leader>q :bdelete<CR>
nnoremap <leader>b :buffers<CR>:buffer<Space>

" Better Window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

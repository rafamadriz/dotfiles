""""""""""""""""""""""
"  General Settings  "
""""""""""""""""""""""
filetype plugin indent on
syntax on
set backspace=indent,eol,start
set hidden
set path+=.,**
set colorcolumn=80
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab
set autoindent smartindent
set incsearch ignorecase smartcase nohlsearch
set numberwidth=1 relativenumber nu title
set viminfo+=n$HOME/.config/nvim/viminfo
set completeopt=menuone,longest,noselect
set omnifunc=syntaxcomplete#Complete
set noswapfile nobackup undofile
set clipboard+=unnamedplus
set showcmd noshowmode
set complete+=k,kspell complete-=w complete-=b complete-=u complete-=t
set updatetime=50
set scrolloff=10
set termguicolors
set encoding=UTF-8
set noerrorbells
set shortmess+=c
set nowrap
set showmatch
set wildmode=list,full
set wildmenu
set cursorline
set nocompatible
set mouse=a
set splitbelow splitright

colorscheme tender

" jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Automatically deletes all trailing whitespace and newlines at end of file on save.
au BufWritePre * %s/\s\+$//e
au BufWritePre * %s/\n\+\%$//e
au BufWritePre *.[ch] %s/\%$/\r/e

"--------------------- Mappings -------------------
" AUTOCOMPLETE
" - ^n - autocomplete suggestions (next)
" - ^p - autocomplete suggestions (previous)
" - ^x^f - for filenames
" - ^x^] - tags only

let mapleader = " "

inoremap jk <ESC>
nnoremap Q <Nop>
nmap <leader>w :update<CR>
nmap <leader>q :bdelete<CR>
nnoremap <leader>b :buffers<CR>:buffer<Space>

" Better Window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Move selected line / block of text in visual mode
xmap K :move '<-2<CR>gv-gv
xmap J :move '>+1<CR>gv-gv

" Check file in shellcheck
nmap <leader>s :!clear && shellcheck %<CR>

"""""""""""""""""""""""
"  Autocomplete Menu  "
"""""""""""""""""""""""
set omnifunc=htmlcomplete#CompleteTags
set omnifunc=csscomplete#CompleteCSS
set omnifunc=javascriptcomplete#CompleteJS

inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Tweaks for browsing files
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

""""""""""""""""
"  Statusline  "
""""""""""""""""
highlight Comment gui=italic

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
set laststatus=2

set statusline=
set statusline+=%4*
set statusline+=[%n]
set statusline+=%1*
" Show current mode
set statusline+=\ %{toupper(g:currentmode[mode()])}
set statusline+=%{&spell?'[SPELL]':''}

set statusline+=%#WarningMsg#
set statusline+=%{&paste?'[PASTE]':''}

set statusline+=%2*
" File path, as typed or relative to current directory
set statusline+=\ %F

set statusline+=%{&modified?'\ [+]':''}
set statusline+=%{&readonly?'\ []':''}

" Truncate line here
set statusline+=%<

" Separation point between left and right aligned items.
set statusline+=%=

set statusline+=%{&filetype!=#''?&filetype.'\ ':'none\ '}

" Encoding & Fileformat
set statusline+=%#WarningMsg#
set statusline+=%{&fileencoding!='utf-8'?'['.&fileencoding.']':''}

set statusline+=%2*

" Warning about byte order
set statusline+=%#WarningMsg#
set statusline+=%{&bomb?'[BOM]':''}

set statusline+=%3*
" Location of cursor line
set statusline+=[%l/%L]

set statusline+=%1*
" Column number
set statusline+=\ col:%2c

" Warning about trailing spaces.
set statusline+=%#WarningMsg#
set statusline+=%{StatuslineTabWarning()}

" Find if they are mixed indentings.
function! StatuslineTabWarning()
    if !exists('b:statusline_tab_warning')
        " If the file is unmodifiable, do not warn this.
        if !&modifiable
            let b:statusline_trailing_space_warning = ''
            return b:statusline_trailing_space_warning
        endif

        let has_leading_tabs = search('^\t\+', 'nw') != 0
        let has_leading_spaces = search('^ \+', 'nw') != 0

        if has_leading_tabs && has_leading_spaces
            let b:statusline_tab_warning = ' [mixed-indenting]'
        elseif has_leading_tabs
            let b:statusline_tab_warning = ' [tabbed-indenting]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif

    return b:statusline_tab_warning
endfunction

hi user1 guifg=#1d1d1d guibg=#8ec07c
hi user2 guifg=#fff guibg=#3c3836
hi user3 guifg=#fff guibg=#504945
hi user4 guifg=#fff guibg=#282828

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi User1 guibg=#83a598
  else
    hi User1 guibg=#8ec07c
  endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi User1 guibg=#8ec07c

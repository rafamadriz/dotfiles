set backspace=indent,eol,start
set clipboard=unnamedplus
set showcmd
set background=dark
set showtabline=2
set shortmess+=c
set path+=.,**
set mouse=a
" BACKUP
set noswapfile nobackup undofile nowritebackup
" search and complete
set incsearch
set ignorecase
set smartcase
set nohlsearch
set completeopt=menuone,noinsert,noselect
if has('nvim')
    set inccommand=nosplit
endif
" indent
set autoindent smartindent
set softtabstop=4 shiftwidth=4
set expandtab smarttab
set nowrap
" number
set relativenumber number
" display
set wildmenu
set termguicolors
set cursorline
set cmdheight=2
set scrolloff=10
set signcolumn=yes
set showbreak=↪
set showtabline=2
set noshowmode
set encoding=UTF-8
set title
" grep program
if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading\ --smartcase
endif
" diff
set diffopt=vertical,iwhite,hiddenoff,foldcolumn:0,context:4,algorithm:histogram,indent-heuristic
" time
set updatetime=300 timeoutlen=300
" window splitting and buffers
set hidden
set splitbelow splitright

filetype plugin on
syntax on

let mapleader = ' '

imap jk <ESC>
nnoremap Y y$
vnoremap Y <ESC>y$gv
nmap Q <Nop>
vmap $ g_
nnoremap n nzzzv
nnoremap N nzzzv
nnoremap J mzJ`z
nnoremap <BS> <C-^>
tnoremap <C-o> <C-\><C-n>
" move selected line/block of text
xnoremap K :move '<-2<CR>gv=gv
xnoremap J :move '>+2<CR>gv=gv
" deal with word wrap in normal and visual mode
nnoremap <expr> k v:count == 0 ? "gk" : "k"
nnoremap <expr> j v:count == 0 ? "gj" : "j"
xnoremap <expr> k (v:count == 0 && mode() !=# "V") ? "gk" : "k"
xnoremap <expr> j (v:count == 0 && mode() !=# "V") ? "gj" : "j"
" jump to end of pasted text
nnoremap p p`]
vnoremap p p`]
vnoremap y y`]
" keep visual selection when indenting
vnoremap < <gv
vnoremap > >gv
" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nmap <leader>bq :bdelete<CR>
nmap <leader>bs :update<CR>
nmap <leader>wq :close<CR>

let data_dir = has('nvim') ? stdpath('config') : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(has('nvim') ? stdpath('config') . '/plug' : '~/.vim/plug')
" improve editing
Plug 'machakann/vim-sandwich'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'

" fzf for life
Plug 'junegunn/fzf.vim'
let g:fzf_layout = { 'down': '35%' }
nmap <leader><Space> :Files<CR>
nmap <leader>bb :Buffers<CR>
nmap <leader>fg :Rg<CR>
nmap <leader>fb :BLines<CR>
nmap <leader>fr :History<CR>
nmap <leader>fc :History:<CR>
nmap <leader>fs :History/<CR>
nmap <leader>fh :Helptags<CR>
nmap <leader>gf :GFiles<CR>
nmap <leader>gc :Commits<CR>

" Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-rooter'
let g:rooter_silent_chdir = 1

" theme
Plug 'itchyny/lightline.vim'
Plug 'gruvbox-community/gruvbox'
Plug 'sheerun/vim-polyglot'
call plug#end()

silent! colorscheme gruvbox
" lightline
let g:lightline = { 'colorscheme': 'gruvbox' }

" Automatically deletes all trailing whitespace and newlines at end of file on save.
au BufWritePre * %s/\s\+$//e
au BufWritePre * %s/\n\+\%$//e
au BufWritePre *.[ch] %s/\%$/\r/e

" jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Format Options
augroup FmtOptions
    au!
    au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

if has('nvim')
    augroup highlight_yank
        autocmd!
        au TextYankPost * silent! lua vim.highlight.on_yank{timeout=250}
    augroup END
endif

" Terminal
augroup Terminal
        au!
        if has('nvim')
            au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
            au TermOpen * nnoremap <buffer> <leader>bq :bdelete!<CR>
            au TermOpen * startinsert
            au TermOpen * set nonumber norelativenumber
        else
            au TerminalOpen * tnoremap <buffer> <Esc> <c-\><c-n>
            au TerminalOpen * nnoremap <buffer> <leader>bq :bdelete!<CR>
            au TerminalOpen * startinsert
            au TerminalOpen * set nonumber norelativenumber
        endif
augroup END

" CoC
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nmap <silent> <C-p> <Plug>(coc-diagnostic-prev)
nmap <silent> <C-n> <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>lr <Plug>(coc-rename)
xmap <leader>rf  <Plug>(coc-format-selected)
nmap <leader>rf  <Plug>(coc-format-selected)
nnoremap <silent><nowait> <leader>ld  :<C-u>CocList diagnostics<cr>
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

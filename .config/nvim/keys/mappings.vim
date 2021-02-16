let mapleader = " "

"--------------------- Mini Wiki (Useful Commands) -------------------
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
nnoremap <F5> :buffers<CR>:buffer<Space>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Use shift + hjkl to resize windows
nnoremap <S-k>  :resize -2<CR>
nnoremap <S-j>  :resize +2<CR>
nnoremap <S-h>  :vertical resize -2<CR>
nnoremap <S-l>  :vertical resize +2<CR>

" NERDTree
nnoremap = :call nerdtree#invokeKeyMap("o")<CR>
nnoremap <silent> <leader>f :NERDTreeToggle %<CR>

" FZF
nnoremap <silent> <C-p> :FZF<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>h :Rg<CR>

" Tabs  navigation
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

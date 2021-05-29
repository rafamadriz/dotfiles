" Autosize quickfix to match its minimum content
" https://vim.fandom.com/wiki/Automatically_fitting_a_quickfix_window_height
function! s:adjust_height(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

" force quickfix to open beneath all other splits
wincmd J

setlocal number
setlocal norelativenumber
setlocal nowrap
setlocal signcolumn=yes
setlocal colorcolumn=
set nobuflisted " quickfix buffers should not pop up when doing :bn or :bp
call s:adjust_height(1, 10)
setlocal winfixheight

highlight! link QuickFixLine CursorLine

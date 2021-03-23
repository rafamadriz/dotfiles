" Automatically deletes all trailing whitespace and newlines at end of file on save.
au BufWritePre * %s/\s\+$//e
au BufWritePre * %s/\n\+\%$//e
au BufWritePre *.[ch] %s/\%$/\r/e

" jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" EJS
au BufNewFile,BufRead *.ejs set filetype=html

"Markdown
autocmd FileType markdown let g:indentLine_enabled=0

" Automatically install coc-extensions
let g:coc_global_extensions=["coc-stylelintplus", "coc-prettier", "coc-pairs", "coc-html", "coc-emmet", "coc-cssmodules", "coc-tsserver", "coc-json", "coc-css", "coc-sh", "coc-pyright"]

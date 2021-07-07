" Set filetypes
augroup Filetypes
  au!
  au BufNewFile,BufRead *.ejs,*.hbs set filetype=html
  au BufWritePost config.lua PackerCompile
augroup END

" Terminal
augroup Terminal
    au!
    au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    au TermOpen * set nonumber norelativenumber
augroup END

" Format Options
augroup FmtOptions
    au!
    au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

" Create missing directories when saving file
augroup Mkdir
    au!
    au BufWritePre * lua require'utils.extra'.mkdir()
augroup END

" exit LspInfo window with q"
augroup LspInfo
    au!
    au FileType lspinfo nnoremap <silent> <buffer> q :q<CR>
augroup END

" Set filetypes
augroup Filetypes
  au!
  au BufNewFile,BufRead *.ejs,*.hbs set filetype=html
  au BufNewFile,BufRead *.nix set filetype=nix
  au BufWritePost config.lua PackerCompile
  au FileType NeogitCommitMessage set spell textwidth=72
augroup END

" Terminal
augroup Terminal
    au!
    au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    au TermOpen * tnoremap <buffer> <C-o> <c-\><c-n>
    au TermOpen * tnoremap <buffer> <silent> <C-j> <c-\><c-n>:wincmd j<CR>
    au TermOpen * tnoremap <buffer> <silent> <C-k> <c-\><c-n>:wincmd k<CR>
    au TermOpen * startinsert
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
    au BufWritePre * lua require'core.util'.mkdir()
augroup END

" exit LspInfo window with q"
augroup LspInfo
    au!
    au FileType lspinfo nnoremap <silent> <buffer> q :q<CR>
augroup END

" trim trailing white space
augroup TrimTrailing
    au!
    au BufWritePre * %s/\s\+$//e
    au BufWritePre * %s/\n\+\%$//e
augroup END

" Set filetypes
augroup Filetypes
  au!
  au BufNewFile,BufRead *.ejs,*.hbs set filetype=html
  au BufNewFile,BufRead *.nix set filetype=nix
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
    au BufWritePre * lua require'core.util'.mkdir()
augroup END

" exit LspInfo window with q"
augroup LspInfo
    au!
    au FileType lspinfo nnoremap <silent> <buffer> q :q<CR>
augroup END

lua << EOF
function _G.webDevIcons(path)
  local filename = vim.fn.fnamemodify(path, ':t')
  local extension = vim.fn.fnamemodify(path, ':e')
  return require'nvim-web-devicons'.get_icon(filename, extension, { default = true })
end
EOF

function! StartifyEntryFormat() abort
  return 'v:lua.webDevIcons(absolute_path) . " " . entry_path'
endfunction

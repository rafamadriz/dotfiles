-- check if option to set autocommand
local function check_and_set(option, au_type, where, dispatch, boolean)
    if as._default(option, boolean) == true then
        as.nvim_set_au(au_type, where, dispatch)
    end
end

as.nvim_set_au("BufWritePost", "pack.lua", "PackerCompile")
as.nvim_set_au("BufNewFile,BufRead", "*.ejs", "set filetype=html")
as.nvim_set_au("FileType", "markdown", "setlocal wrap spell")
as.nvim_set_au("FileType", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o")
as.nvim_set_au("FileType", "toggleterm", "setlocal nonumber norelativenumber")
as.nvim_set_au("TermOpen", "*", [[tnoremap <buffer> <Esc> <c-\><c-n>]])
as.nvim_set_au("TermOpen", "*", "set nonu")

check_and_set(vim.g.neon_highlight_yank, "TextYankPost", "*", 'lua require"vim.highlight".on_yank()')
check_and_set(vim.g.neon_trim_trailing_space, "BufWritePre", "*", [[%s/\s\+$//e]])
check_and_set(vim.g.neon_trim_trailing_space, "BufWritePre", "*", [[%s/\n\+\%$//e]])
check_and_set(
    vim.g.neon_preserve_cursor,
    "BufReadPost",
    "*",
    [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
)
check_and_set(
    vim.g.neon_format_on_save,
    "BufWritePre",
    "*",
    [[try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry]]
)

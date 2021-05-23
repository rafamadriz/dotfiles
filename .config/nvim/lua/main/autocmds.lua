local nvim_set_au = as.nvim_set_au

-- check if option to set autocommand
local function check_and_set(option, au_type, where, dispatch, boolean)
    if as._default(option, boolean) == true then
        nvim_set_au(au_type, where, dispatch)
    end
end

nvim_set_au("ColorScheme", "*", [[lua require("lsp.config").fix("ColorScheme")]])
nvim_set_au("BufWritePost", "pack.lua", "PackerCompile")
nvim_set_au("BufNewFile,BufRead", "*.ejs", "set filetype=html")
nvim_set_au("FileType", "markdown", "setlocal wrap spell")
nvim_set_au("FileType", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o")
nvim_set_au("FileType", "toggleterm", "setlocal nonumber norelativenumber")
nvim_set_au("TermOpen", "*", [[tnoremap <buffer> <Esc> <c-\><c-n>]])
nvim_set_au("TermOpen", "*", "set nonu")

check_and_set(Opts.highlight_yank, "TextYankPost", "*", 'lua require"vim.highlight".on_yank()')
check_and_set(Formatting.trim_trailing_space, "BufWritePre", "*", [[%s/\s\+$//e]])
check_and_set(Formatting.trim_trailing_space, "BufWritePre", "*", [[%s/\n\+\%$//e]])
check_and_set(
    Opts.preserve_cursor,
    "BufReadPost",
    "*",
    [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
)
check_and_set(
    Formatting.format_on_save,
    "BufWritePre",
    "*",
    [[try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry]]
)

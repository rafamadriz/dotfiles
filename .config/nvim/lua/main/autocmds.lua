local u = require("utils.core")

u.define_augroups(
    {
        trim_whitespaces = {
            {"BufWritePre", "*", [[%s/\s\+$//e]]},
            {"BufWritePre", "*", [[%s/\n\+\%$//e]]},
            {"BufWritePre", "*.[ch]", [[*.[ch] %s/\%$/\r/e]]}
        },
        jump_last = {
            {"BufReadPost", "*", [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]}
        },
        format = {
            {
                "BufWritePre",
                "*",
                [[try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry]]
            }
        },
        filetypes = {
            {"BufNewFile,BufRead", "*.ejs", "set filetype=html"},
            {"FileType", "markdown", "setlocal wrap"},
            {"FileType", "markdown", "setlocal spell"},
            {"FileType", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o"}
        },
        cursor = {
            {"CursorHold", "*", "lua vim.lsp.diagnostic.show_line_diagnostics()"},
            {"CursorHoldI", "*", "silent! lua vim.lsp.buf.signature_help()"}
        },
        hl_yank = {
            {"TextYankPost", "*", 'lua require"vim.highlight".on_yank()'}
        }
    }
)

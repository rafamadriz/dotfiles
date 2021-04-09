local u = require("utils.core")

local autocmds = {
    jump_last = {
        {"BufReadPost", "*", [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]}
    },
    filetypes = {
        {"BufNewFile,BufRead", "*.ejs", "set filetype=html"},
        {"FileType", "markdown", "setlocal wrap"},
        {"FileType", "markdown", "setlocal spell"},
        {"FileType", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o"},
        {"FileType", "toggleterm", "setlocal nonumber norelativenumber"}
    },
    cursor = {
        {"CursorHold", "*", "lua vim.lsp.diagnostic.show_line_diagnostics()"},
        {"CursorHoldI", "*", "silent! lua vim.lsp.buf.signature_help()"}
    },
    hl_yank = {
        {"TextYankPost", "*", 'lua require"vim.highlight".on_yank()'}
    }
}

local format = {
    {
        "BufWritePre",
        "*",
        [[try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry]]
    }
}

local trim_whitespaces = {
    {"BufWritePre", "*", [[%s/\s\+$//e]]},
    {"BufWritePre", "*", [[%s/\n\+\%$//e]]}
    -- {"BufWritePre", "*.[ch]", [[*.[ch] %s/\%$/\r/e]]}
}

if Formatting.format_on_save == true or Formatting.format_on_save == nil then
    table.insert(autocmds, format)
end

if Formatting.trim_trailing_space == true or Formatting.trim_trailing_space == nil then
    table.insert(autocmds, trim_whitespaces)
end

u.define_augroups(autocmds)

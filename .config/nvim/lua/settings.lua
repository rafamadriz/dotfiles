local u = require("utils")
local cmd = vim.cmd

-- Global
u.opt("o", "incsearch", true)
u.opt("o", "ignorecase", true)
u.opt("o", "smartcase", true)
u.opt("o", "smarttab", true)
u.opt("o", "title", true)
u.opt("o", "backup", false)
u.opt("o", "writebackup", false)
u.opt("o", "clipboard", "unnamedplus")
u.opt("o", "showmode", false)
u.opt("o", "pumheight", 10)
u.opt("o", "showtabline", 2)
u.opt("o", "updatetime", 100)
u.opt("o", "scrolloff", 10)
u.opt("o", "cmdheight", 2)
u.opt("o", "termguicolors", true)
u.opt("o", "mouse", "a")
u.opt("o", "hidden", true)
u.opt("o", "splitbelow", true)
u.opt("o", "splitright", true)
u.opt("o", "completeopt", "menuone,noinsert,noselect")

-- Window
u.opt("w", "relativenumber", true)
u.opt("w", "number", true)
u.opt("w", "numberwidth", 1)
u.opt("w", "wrap", false)
u.opt("w", "cursorline", true)
u.opt("w", "conceallevel", 0)

-- Buffer
local indent = 2
u.opt("b", "tabstop", indent)
u.opt("b", "softtabstop", indent)
u.opt("b", "shiftwidth", indent)
u.opt("b", "expandtab", true)
u.opt("b", "autoindent", true)
u.opt("b", "smartindent", true)
u.opt("b", "swapfile", false)
u.opt("b", "undofile", true)
u.opt("b", "fileencoding", "utf-8")
u.opt("b", "syntax", "on")

-- Commands
cmd("set shortmess+=c")
cmd("set iskeyword+=-")
cmd("set path+=**")
cmd("filetype plugin on")

-- Autocommands
cmd [[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
cmd [[au BufNewFile,BufRead *.ejs set filetype=html]]
cmd [[au FileType markdown let g:indentLine_enabled=0]]
-- Automatically deletes all trailing whitespace and newlines at end of file on save.
cmd [[au BufWritePre * %s/\s\+$//e]]
cmd [[au BufWritePre * %s/\n\+\%$//e]]
cmd [[au BufWritePre *.[ch] %s/\%$/\r/e]]
-- Disables automatic commenting on newline:
cmd [[au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]]
-- Neoformat
cmd [[au BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry]]
-- Source init.lua one save
cmd [[au BufWritePre plugins.lua luafile %]]

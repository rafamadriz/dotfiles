local u = require("utils")
local cmd = vim.cmd

vim.g.mapleader = " "

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

-- Basics
u.map("n", "<leader>w", ":w<CR>")
u.map("n", "<leader>q", ":bdelete<CR>")
u.map("i", "jk", "<ESC>")
u.map("n", "Q", "<Nop>")

-- Better window navigation
u.map("n", "<C-h>", "<C-w>h")
u.map("n", "<C-j>", "<C-w>j")
u.map("n", "<C-k>", "<C-w>k")
u.map("n", "<C-l>", "<C-w>l")

-- Resize windows
u.map("n", "<S-k>", ":resize -2<CR>")
u.map("n", "<S-j>", ":resize +2<CR>")
u.map("n", "<S-h>", ":vertical resize -2<CR>")
u.map("n", "<S-l>", ":vertical resize +2<CR>")

-- buffer navigation
u.map("n", "<TAB>", ":bnext<CR>")
u.map("n", "<S-TAB>", ":bprevious<CR>")

-- File manager
u.map("n", "<leader>e", ":NvimTreeToggle<CR>")

-- Telescope
u.map("n", "<leader>ff", ":Telescope find_files<CR>")
u.map("n", "<leader>fg", ":Telescope live_grep<CR>")
u.map("n", "<leader>b", ":Telescope buffers<CR>")
u.map("n", "<leader>fh", ":Telescope help_tags<CR>")
u.map("n", "<leader>dot", [[:lua require('utils').search_dotfiles()<CR>]])

-- LSP
u.map("n", "gd", ":lua vim.lsp.buf.definition()<CR>")
u.map("n", "gD", ":lua vim.lsp.buf.declaration()<CR>")
u.map("n", "gt", ":lua vim.lsp.buf.type_definition()<CR>")
u.map("n", "gr", ":lua vim.lsp.buf.references()<CR>")
u.map("n", "K", ":lua vim.lsp.buf.hover()<CR>")
u.map("n", "gi", ":lua vim.lsp.buf.implementation()<CR>")
u.map("n", "<space>rn", ":lua vim.lsp.buf.rename()<CR>")
u.map("n", "<C-p>", ":lua vim.lsp.diagnostic.goto_prev()<CR>")
u.map("n", "<C-n>", ":lua vim.lsp.diagnostic.goto_next()<CR>")

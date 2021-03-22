local u = require('utils')
local cmd = vim.cmd

vim.g.mapleader = ' '

-- Autocommands
cmd[[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
cmd[[au BufNewFile,BufRead *.ejs set filetype=html,js]]
cmd[[au FileType markdown let g:indentLine_enabled=0]]
cmd[[au BufWritePre * %s/\s\+$//e]]

-- Basics
u.map('n', '<leader>w', ':w<CR>')
u.map('n', '<leader>q', ':bdelete<CR>')
u.map('i', 'jk', '<ESC>')
u.map('n', 'Q', '<Nop>')

-- Better window navigation
u.map('n', '<C-h>', '<C-w>h')
u.map('n', '<C-j>', '<C-w>j')
u.map('n', '<C-k>', '<C-w>k')
u.map('n', '<C-l>', '<C-w>l')

-- Resize windows
u.map('n', '<S-k>', ':resize -2<CR>')
u.map('n', '<S-j>', ':resize +2<CR>')
u.map('n', '<S-h>', ':vertical resize -2<CR>')
u.map('n', '<S-l>', ':vertical resize +2<CR>')

-- buffer navigation
u.map('n', 'bn', ':bn<CR>')
u.map('n', 'bp', ':bp<CR>')

-- File manager
u.map('n', '<leader>e', ':NvimTreeToggle<CR>')

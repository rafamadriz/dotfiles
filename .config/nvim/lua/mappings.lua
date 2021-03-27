local u = require("utils")

vim.g.mapleader = " "

-- Basics
u.map("n", "<leader>w", ":w<CR>")
u.map("n", "<leader>q", ":BufferClose<CR>")
u.map("i", "jk", "<ESC>")
u.map("n", "Q", "<Nop>")
-- Move selected line / block of text in visual mode
u.map("x", "K", ":move '<-2<CR>gv-gv")
u.map("x", "J", ":move '>+1<CR>gv-gv")

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
u.map("n", "<TAB>", ":BufferNext<CR>")
u.map("n", "<S-TAB>", ":BufferPrevious<CR>")
u.map("n", "<A-1>", ":BufferGoto 1<CR>")
u.map("n", "<A-2>", ":BufferGoto 2<CR>")
u.map("n", "<A-3>", ":BufferGoto 3<CR>")
u.map("n", "<A-4>", ":BufferGoto 4<CR>")
u.map("n", "<A-5>", ":BufferGoto 5<CR>")
u.map("n", "<A-6>", ":BufferGoto 6<CR>")
u.map("n", "<A-7>", ":BufferGoto 7<CR>")
u.map("n", "<A-8>", ":BufferGoto 8<CR>")
u.map("n", "<A-9>", ":BufferGoto 9<CR>")
u.map("n", "<A-l>", ":BufferLast<CR>")

-- File manager
u.map("n", "<leader>e", ":NvimTreeToggle<CR>")

-- Telescope
u.map("n", "<leader>ff", ":Telescope find_files<CR>")
u.map("n", "<leader>fg", ":Telescope live_grep<CR>")
u.map("n", "<leader>fm", ":Telescope media_files<CR>")
u.map("n", "<leader>b", ":Telescope buffers<CR>")
u.map("n", "<leader>fh", ":Telescope help_tags<CR>")
u.map("n", "<leader>dot", ":lua require('utils').search_dotfiles()<CR>")

-- LSP
u.map("n", "gd", ":lua vim.lsp.buf.definition()<CR>")
u.map("n", "gD", ":lua vim.lsp.buf.declaration()<CR>")
u.map("n", "gt", ":lua vim.lsp.buf.type_definition()<CR>")
u.map("n", "gr", ":lua vim.lsp.buf.references()<CR>")
u.map("n", "gh", ":lua vim.lsp.buf.hover()<CR>")
u.map("n", "gi", ":lua vim.lsp.buf.implementation()<CR>")
u.map("n", "<space>rn", ":lua vim.lsp.buf.rename()<CR>")
u.map("n", "<C-p>", ":lua vim.lsp.diagnostic.goto_prev()<CR>")
u.map("n", "<C-n>", ":lua vim.lsp.diagnostic.goto_next()<CR>")

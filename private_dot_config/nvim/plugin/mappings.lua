if not as then
    return
end

local nmap = as.nmap
local nnoremap = as.nnoremap
local vnoremap = as.vnoremap
local vmap = as.vmap
local xnoremap = as.xnoremap
local cmap = as.cmap

--------------------------------------------------------------------------------
-- Space as leaderkey
--------------------------------------------------------------------------------
nmap('n', '<Space>', '<Nop>', { silent = true })
vmap('n', '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--------------------------------------------------------------------------------
-- The Basics
--------------------------------------------------------------------------------
vnoremap("Y", "<ESC>y$gv", { desc = "Yank to last character" })
nnoremap("Q", "<Nop>", { desc = "Disable repeat last recorded character" })
nnoremap("$", "g_", { desc = "Move to last character instead of end of line" })
nnoremap("n", "nzzzv", { desc = "Center buffer when repeating search" })
nnoremap("N", "Nzzzv", { desc = "Center buffer when repeating reverse search" })
nnoremap("J", "mzJ`z", { desc = "Keep cursor position when joinng lines" })
nnoremap("<BS>", "<C-^>", { desc = "Jump between last two buffers" })
cmap("Q", "q", { desc = "Always write q" })
cmap("W", "w", { desc = "Always write w" })
xnoremap("K", ":move '<-2<CR>gv=gv", { desc = "Move selected block of text up" })
xnoremap("J", ":move '>+1<CR>gv=gv", { desc = "Move selected block of text down" })
nnoremap("k", [[v:count == 0 ? "gk" : "k"]], { expr = true, desc = "Move up in wraped lines as normal lines" })
nnoremap("j", [[v:count == 0 ? "gj" : "j"]], { expr = true, desc = "Move down in wraped lines as normal lines" })
xnoremap("k", [[(v:count == 0 && mode() !=# "V") ? "gk" : "k"]], { expr = true, desc = "Move up in wraped lines as nornal lines" })
xnoremap("j", [[(v:count == 0 && mode() !=# "V") ? "gj" : "j"]], { expr = true, desc = "Move down in wraped lines as nornal lines" })
vnoremap("y", "y`]", { desc = "Keep cursor position when yanking text" })
nnoremap("p", "p`]", { desc = "Jump to end of pasted text" })
vnoremap("p", "p`]", { desc = "Jump to end of pasted text" })
cmap("<C-a>", "<home>", { desc = "Move to end of line" })
cmap("<C-e>", "<end>", { desc = "Move to begining of line" })
vnoremap("<", "<gv", { desc = "Keep visual selection when indenting to left" })
vnoremap(">", ">gv", { desc = "Keep visual selection when indenting to right" })

--------------------------------------------------------------------------------
-- Buffers
--------------------------------------------------------------------------------
nnoremap("<leader>bs", ":update<CR>", { desc = "Save buffer" })
vnoremap("<leader>bs", "<ESC>:update<CR>gv", { desc = "Save buffer" })
nnoremap("<leader>bq", ":close<CR>", { desc = "Quit buffer" })
nnoremap("<leader>bQ", ":write | silent %bd | silent e# | bd#<CR>", { desc = "Quit all buffers but current" })

--------------------------------------------------------------------------------
-- Pair of bracket mappings
--------------------------------------------------------------------------------
nnoremap("[b", ":bprevious<CR>", { desc = "Previous buffer" })
nnoremap("]b", ":bnext<CR>", { desc = "Next buffer" })
nnoremap("[l", ":lprevious<CR>zzzv", { desc = "Previous in location list" })
nnoremap("]l", ":lnext<CR>zzzv", { desc = "Next in location list" })
nnoremap("[q", ":cprevious<CR>zzzv", { desc = "Previous in quickfix list" })
nnoremap("]q", ":cnext<CR>zzzv", { desc = "Next in quickfix list" })
nnoremap("[t", ":tprevious<CR>", { desc = "Previous tab" })
nnoremap("]t", ":tnext<CR>", { desc = "Next tab" })
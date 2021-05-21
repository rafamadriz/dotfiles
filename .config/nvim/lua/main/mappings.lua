local map = as.map

-- NOTE: in telescope use <C-q> to send all results to quickfix
-- and <M-q> | <A-q> to send selected items

vim.g.mapleader = " "

map("n", "Q", "<Nop>")
map("n", "<BS>", "<C-^>")
map("n", "Y", "y$")
map("t", "<C-o>", [[<C-\><C-n>]])
map("n", "<A-t>", ":ToggleTerm<CR>")
map("t", "<A-t>", [[<C-\><C-n>:ToggleTerm<CR>]])
map("i", "jk", [[col('.') == 1 ? '<esc>' : '<esc>l']], {expr = true})

-- Move selected line / block of text in visual mode
map("x", "K", ":move '<-2<CR>gv=gv")
map("x", "J", ":move '>+1<CR>gv=gv")

-- Remap for dealing with word wrap in Normal mode
map("n", "k", 'v:count == 0 ? "gk" : "k"', {expr = true})
map("n", "j", 'v:count == 0 ? "gj" : "j"', {expr = true})
-- same for visual mode
map("x", "k", '(v:count == 0 && mode() !=# "V") ? "gk" : "k"', {expr = true})
map("x", "j", '(v:count == 0 && mode() !=# "V") ? "gj" : "j"', {expr = true})

-- Automatically jump to the end of pasted text
map("v", "y", "y`]")
map("v", "p", "p`]")
map("n", "p", "p`]")
-- Select last pasted text
map("n", "gp", "'`[' . strpart(getregtype(), 0, 1) . '`]'", {expr = true})

-- Better window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Resize windows
map("n", "<S-k>", ":resize -2<CR>")
map("n", "<S-j>", ":resize +2<CR>")
map("n", "<S-h>", ":vertical resize -2<CR>")
map("n", "<S-l>", ":vertical resize +2<CR>")

-- File manager
map("n", "<leader>e", ":NvimTreeToggle<CR>")

-- dotree
map("n", "<leader>u", ":UndotreeToggle<CR>")

-- new files
map("n", "<leader>nb", [[:enew<CR>]], {silent = false})
map("n", "<leader>nf", [[:e <C-R>=expand("%:p:h") . "/" <CR>]], {silent = false})
map("n", "<leader>ns", [[:vsp <C-R>=expand("%:p:h") . "/" <CR>]], {silent = false})
map("n", "<leader>nt", [[:tabedit <C-R>=expand("%:p:h") . "/" <CR>]], {silent = false})

-- help
map("n", "<leader>hv", ":Telescope help_tags<CR>")
map("n", "<leader>hm", ":Telescope man_pages<CR>")

-- buffer navigation
map("n", "<TAB>", ":bn<CR>")
map("n", "<S-TAB>", ":bp<CR>")
-- buffers
map("n", "<leader>bb", ":Telescope buffers<CR>") -- all buffers
map("n", "<leader>bs", ":update<CR>") -- save buffer
map("n", "<leader>bS", ":wa<CR>") -- save all buffers
map("n", "<leader>bq", ":update | bdelete<CR>") -- quit buffer
map("n", "<leader>bQ", [[<cmd>w <bar> %bd <bar> e#<CR>]]) -- quit all buffers but current
map("n", "<leader>b%", ":luafile %<CR>", {silent = false}) -- source buffer
map("n", "<leader>bh", ":noh<CR>") -- No highlight
map("n", "<leader>b]", ":bn<CR>") -- buffer next
map("n", "<leader>b[", ":bp<CR>") -- buffer previous

-- windows
map("n", "<leader>ww", "<C-w>q") -- cycle through window
map("n", "<leader>wq", "<C-w>q") -- quit window
map("n", "<leader>ws", "<C-w>s") -- split window
map("n", "<leader>wv", "<C-w>v") -- vertical split
map("n", "<leader>wh", "<C-w>h") -- jump to left window
map("n", "<leader>wj", "<C-w>j") -- jump to the down window
map("n", "<leader>wk", "<C-w>k") -- jump to the up window
map("n", "<leader>wl", "<C-w>l") -- jump to right window
map("n", "<leader>wm", "<C-w>|") -- max out to fullscreen
map("n", "<leader>w=", "<C-w>=") -- equally high and width
map("n", "<leader>wT", "<C-w>T") -- break out into a new tab
map("n", "<leader>wr", "<C-w>x") -- replace current with next
map("n", "<leader>w<", ":vertical resize -10<CR>") -- decrease width
map("n", "<leader>w>", ":vertical resize +10<CR>") -- increase width
map("n", "<leader>w-", ":resize -15<CR>") -- decrease height
map("n", "<leader>w+", ":resize +15<CR>") -- increase height

-- Git
map("n", "<F5>", ":lua as.lazygit_toggle()<CR>") -- lazygit
map("n", "<leader>ga", ":Git add %<CR>") -- add current file
map("n", "<leader>gd", ":Git diff %<CR>") -- show diff
map("n", "<leader>gC", ":Git commit %<CR>") -- commit
map("n", "<leader>gL", ":Git log %<CR>") -- log
map("n", "<leader>gf", ":Telescope git_files<CR>") -- git files
map("n", "<leader>gc", ":Telescope git_commits<CR>") -- git commits
map("n", "<leader>gb", ":Telescope git_branches<CR>") -- git branches
map("n", "<leader>gs", ":Telescope git_status<CR>") -- git status
map("n", "<leader>gp", ":Gitsigns preview_hunk<CR>") -- preview hunk
map("n", "<leader>gl", ":Gitsigns toggle_current_line_blame<CR>") -- toggle line blame
map("n", "<leader>gB", ":Git blame<CR>") -- git blame
map("n", "<leader>gr", ":Gitsigns reset_hunk<CR>") -- reset hunk
map("n", "<leader>gR", ":Gitsigns reset_buffer<CR>") -- reset buffer
map("n", "<leader>gu", ":Gitsigns undo_stage_hunk<CR>") -- undo last stage hunk
map("n", "<leader>gI", ":Gitsigns reset_buffer_index<CR>") -- reset buffer index
map("n", "<leader>gt", ":Gitsigns stage_hunk<CR>") -- git stage hunk
map("n", "<leader>gT", ":Gitsigns stage_buffer<CR>") -- git stage buffer
map("n", "<leader>g[", ":Gitsigns prev_hunk<CR>") -- previous hunk
map("n", "<leader>g]", ":Gitsigns next_hunk<CR>") -- next hunk

-- Telescope
map("n", "<leader><space>", ":Telescope find_files<CR>")
map("n", "<leader>ff", ":Telescope find_files<CR>")
map("n", "<leader>fr", ":Telescope oldfiles<CR>")
map("n", "<leader>fg", ":Telescope live_grep<CR>")
map("n", "<leader>fb", ":Telescope current_buffer_fuzzy_find<CR>")
map("n", "<leader>ft", ":Telescope colorscheme<CR>")
map("n", "<leader>fc", ":Telescope command_history<CR>")
map("n", "<leader>fs", ":Telescope search_history<CR>")
map("n", "<leader>fn", ":lua as.search_nvim()<CR>")

-- Zen Mode
map("n", "<leader>zf", [[:lua require("zen-mode").toggle({window = {width = 1}})<CR>]])
map("n", "<leader>zc", [[:lua require("zen-mode").toggle({window = {width = .75}})<CR>]])
map("n", "<leader>zm", [[:lua as.minimal()<CR>]])
map("n", "<leader>za", [[:lua as.ataraxis()<CR>]])

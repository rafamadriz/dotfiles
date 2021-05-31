-- NOTE: in telescope use <C-q> to send all results to quickfix
-- and <M-q> | <A-q> to send selected items

-- NOTE: you can use a regex pattern as part of a range in command mode, E.g.
-- :3,/stop/s/hello/world/g

vim.g.mapleader = " "

as.map("n", "Q", "<Nop>")
as.map("n", "<BS>", "<C-^>")
as.map("n", "Y", "y$")
as.map("t", "<C-o>", [[<C-\><C-n>]])
as.map("n", "<A-t>", ":ToggleTerm<CR>")
as.map("t", "<A-t>", [[<C-\><C-n>:ToggleTerm<CR>]])
as.map("i", "jk", [[col('.') == 1 ? '<esc>' : '<esc>l']], {expr = true})
as.map("n", "0", "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", {expr = true})

-- Move selected line / block of text in visual mode
as.map("x", "K", ":move '<-2<CR>gv=gv")
as.map("x", "J", ":move '>+1<CR>gv=gv")

-- Remap for dealing with word wrap in Normal mode
as.map("n", "k", 'v:count == 0 ? "gk" : "k"', {expr = true})
as.map("n", "j", 'v:count == 0 ? "gj" : "j"', {expr = true})
-- same for visual mode
as.map("x", "k", '(v:count == 0 && mode() !=# "V") ? "gk" : "k"', {expr = true})
as.map("x", "j", '(v:count == 0 && mode() !=# "V") ? "gj" : "j"', {expr = true})

-- Automatically jump to the end of pasted text
as.map("v", "y", "y`]")
as.map("v", "p", "p`]")
as.map("n", "p", "p`]")
-- Select last pasted text
as.map("n", "gp", "'`[' . strpart(getregtype(), 0, 1) . '`]'", {expr = true})

-- Better window navigation
as.map("n", "<C-h>", "<C-w>h")
as.map("n", "<C-j>", "<C-w>j")
as.map("n", "<C-k>", "<C-w>k")
as.map("n", "<C-l>", "<C-w>l")

-- Resize windows
as.map("n", "<S-k>", ":resize -2<CR>")
as.map("n", "<S-j>", ":resize +2<CR>")
as.map("n", "<S-h>", ":vertical resize -2<CR>")
as.map("n", "<S-l>", ":vertical resize +2<CR>")

-- File manager
as.map("n", "<leader>e", ":NvimTreeToggle<CR>")

-- undotree
as.map("n", "<leader>u", ":UndotreeToggle<CR>")

-- new files
as.map("n", "<leader>nb", [[:enew<CR>]], {silent = false})
as.map("n", "<leader>nf", [[:e <C-R>=expand("%:p:h") . "/" <CR>]], {silent = false})
as.map("n", "<leader>ns", [[:vsp <C-R>=expand("%:p:h") . "/" <CR>]], {silent = false})
as.map("n", "<leader>nt", [[:tabedit <C-R>=expand("%:p:h") . "/" <CR>]], {silent = false})

-- help
as.map("n", "<leader>hv", ":Telescope help_tags<CR>")
as.map("n", "<leader>hm", ":Telescope man_pages<CR>")

-- buffer navigation
as.map("n", "<TAB>", ":bn<CR>")
as.map("n", "<S-TAB>", ":bp<CR>")
-- buffers
as.map("n", "<leader>bb", ":Telescope buffers<CR>") -- all buffers
as.map("n", "<leader>bs", ":update<CR>") -- save buffer
as.map("n", "<leader>bS", ":silent! wa<CR>") -- save all buffers
as.map("n", "<leader>bq", ":update | bdelete<CR>") -- quit buffer
as.map("n", "<leader>bQ", [[<cmd>w <bar> %bd <bar> e#<CR>]]) -- quit all buffers but current
as.map("n", "<leader>b%", ":luafile %<CR>", {silent = false}) -- source buffer
as.map("n", "<leader>bh", ":noh<CR>") -- No highlight
as.map("n", "<leader>b]", ":bn<CR>") -- buffer next
as.map("n", "<leader>b[", ":bp<CR>") -- buffer previous

-- windows
as.map("n", "<leader>ww", "<C-w>q") -- cycle through window
as.map("n", "<leader>wq", "<C-w>q") -- quit window
as.map("n", "<leader>ws", "<C-w>s") -- split window
as.map("n", "<leader>wv", "<C-w>v") -- vertical split
as.map("n", "<leader>wh", "<C-w>h") -- jump to left window
as.map("n", "<leader>wj", "<C-w>j") -- jump to the down window
as.map("n", "<leader>wk", "<C-w>k") -- jump to the up window
as.map("n", "<leader>wl", "<C-w>l") -- jump to right window
as.map("n", "<leader>wm", "<C-w>|") -- max out to fullscreen
as.map("n", "<leader>w=", "<C-w>=") -- equally high and width
as.map("n", "<leader>wT", "<C-w>T") -- break out into a new tab
as.map("n", "<leader>wr", "<C-w>x") -- replace current with next
as.map("n", "<leader>w<", ":vertical resize -10<CR>") -- decrease width
as.map("n", "<leader>w>", ":vertical resize +10<CR>") -- increase width
as.map("n", "<leader>w-", ":resize -15<CR>") -- decrease height
as.map("n", "<leader>w+", ":resize +15<CR>") -- increase height

-- Git
as.map("n", "<F5>", ":lua require('utils.extra').lazygit_toggle()<CR>") -- lazygit
as.map("n", "<leader>gg", ":Git<CR>") -- Git
as.map("n", "<leader>ga", ":Git add %<CR>") -- add current file
as.map("n", "<leader>gd", ":Git diff %<CR>") -- show diff
as.map("n", "<leader>gC", ":Git commit %<CR>") -- commit
as.map("n", "<leader>gl", ":Git log %<CR>") -- log
as.map("n", "<leader>gf", ":Telescope git_files<CR>") -- git files
as.map("n", "<leader>gc", ":Telescope git_commits<CR>") -- git commits
as.map("n", "<leader>gb", ":Telescope git_branches<CR>") -- git branches
as.map("n", "<leader>gs", ":Telescope git_status<CR>") -- git status
as.map("n", "<leader>gp", ":Gitsigns preview_hunk<CR>") -- preview hunk
as.map("n", "<leader>gL", ":Gitsigns toggle_current_line_blame<CR>") -- toggle line blame
as.map("n", "<leader>gB", ":Git blame<CR>") -- git blame
as.map("n", "<leader>gr", ":Gitsigns reset_hunk<CR>") -- reset hunk
as.map("n", "<leader>gR", ":Gitsigns reset_buffer<CR>") -- reset buffer
as.map("n", "<leader>gu", ":Gitsigns undo_stage_hunk<CR>") -- undo last stage hunk
as.map("n", "<leader>gI", ":Gitsigns reset_buffer_index<CR>") -- reset buffer index
as.map("n", "<leader>gP", ":Git push<CR>") -- push
as.map("n", "<leader>gi", ":Git init<CR>") -- init
as.map("n", "<leader>gt", ":Gitsigns stage_hunk<CR>") -- git stage hunk
as.map("n", "<leader>gT", ":Gitsigns stage_buffer<CR>") -- git stage buffer
as.map("n", "<leader>g[", ":Gitsigns prev_hunk<CR>") -- previous hunk
as.map("n", "<leader>g]", ":Gitsigns next_hunk<CR>") -- next hunk

-- Telescope
as.map("n", "<leader><space>", ":Telescope find_files<CR>")
as.map("n", "<leader>ff", ":Telescope find_files<CR>")
as.map("n", "<leader>fr", ":Telescope oldfiles<CR>")
as.map("n", "<leader>fg", ":Telescope live_grep theme=get_ivy<CR>")
as.map("n", "<leader>fb", ":Telescope current_buffer_fuzzy_find theme=get_ivy<CR>")
as.map("n", "<leader>ft", ":Telescope colorscheme<CR>")
as.map("n", "<leader>fC", ":Telescope command_history<CR>")
as.map("n", "<leader>fc", ":Telescope commands<CR>")
as.map("n", "<leader>fs", ":Telescope search_history<CR>")
as.map("n", "<leader>fn", ":lua require('utils.extra').search_nvim()<CR>")

-- Zen Mode
as.map("n", "<leader>zf", [[:lua require("zen-mode").toggle({window = {width = 1}})<CR>]])
as.map("n", "<leader>zc", [[:lua require("zen-mode").toggle({window = {width = .75}})<CR>]])
as.map("n", "<leader>zm", [[:lua require('utils.extra').minimal()<CR>]])
as.map("n", "<leader>za", [[:lua require('utils.extra').ataraxis()<CR>]])

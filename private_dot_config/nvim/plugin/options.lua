-- Timings
vim.opt.timeoutlen = 1000 -- Time to wait for a keymap to complete
vim.opt.ttimeoutlen = 300 -- Time to wait for a key code sequence to complete
vim.opt.updatetime = 300 -- If nothing is typed is this time, swap file will be written

-- Window splitting
vim.opt.splitbelow = true -- Horizontal splits will be below
vim.opt.splitright = true -- Vertical splits will be to the right
vim.opt.splitkeep = "screen" -- Keep the text on same line when resizing, closing...

-- Diff options
vim.opt.diffopt = {
    "internal",
    "filler",
    "closeoff",
    "vertical",
    -- "iwhite",
    "hiddenoff",
    "algorithm:histogram",
    "indent-heuristic",
    "linematch:60",
}

-- vim.opt.iskeyword:append "-" -- Words separated by - are regconized as one word for commands like "w"...
vim.opt.iskeyword:remove "_"

-- Message output on vim acctions
vim.opt.shortmess = {
    f = true, -- "(3 of 5)" instead of "(file 3 of 5)"
    i = true, -- "[noeol]" instead of "[Incomplete last line]"
    l = true, -- "999L, 888B" instead of "999 lines, 888 bytes"
    m = true, -- "[+]" instead of "[Modified]"
    n = true, -- "[New]" instead of "[New File]"
    x = true, -- "[unix]" instead if "[unix format]", same with other os's
    s = true, -- don't give "search hit BOTTOM, continuing at TOP"
    t = true, -- truncate file message if it is too long
    A = true, -- Ignore swap file messages
}

-- Display
vim.opt.laststatus = 3 -- Use a single status line for all windows
vim.opt.scrolloff = 2 -- Minimal number of lines to keep above/below the cursor
vim.opt.signcolumn = "auto:2-3"
vim.opt.termguicolors = true
vim.opt.title = true
vim.opt.titlestring = vim.fn.expand "%:p"
vim.opt.confirm = true -- Save me from doing destructive things
vim.opt.showmode = false -- When in insert, show mode in last line
vim.opt.pumheight = 15 -- Maximum number of items to show in the popup menu
vim.opt.completeopt = "menuone,noinsert,fuzzy,popup"
vim.opt.mouse = "a"
vim.o.winborder = "rounded"

-- Indentetion
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.textwidth = 80
vim.opt.virtualedit = "block"

-- Numbers and lines
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- Match and Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- List Chars
vim.opt.list = true
vim.opt.fillchars = {
    eob = " ", -- supress ~ at EndOfBuffer
    diff = "/",
}
vim.opt.listchars = {
    trail = "•",
    -- eol = "↴",
    tab = "» ",
    extends = "…",
    precedes = "…",
    nbsp = "␣",
    space = nil,
}

-- Session options
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions,globals"
vim.opt.exrc = true

-- Use rg as grep program
if vim.fn.executable "rg" > 0 then
    vim.opt.grepprg = [[rg --glob "!.git" --vimgrep --no-heading --smart-case --hidden]]
end
vim.opt.grepformat = "%f:%l:%c:%m"

-- Folds
vim.opt.foldlevelstart = 999
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmethod = "expr"
vim.opt.foldtext = "" -- show original text with its syntax highlighting

-- BACKUP AND SWAP
vim.opt.swapfile = false
vim.opt.undofile = true

-- Wild and file globbing stuff
vim.opt.wildignorecase = true -- Ignore case when completing file names and directories
vim.opt.wildoptions = "pum,fuzzy"
vim.opt.path = ".,**,,"
vim.opt.wildignore = {
    "*.aux",
    "*.out",
    "*.toc",
    "*.o",
    "*.obj",
    "*.dll",
    "*.jar",
    "*.pyc",
    "*.rbc",
    "*.class",
    "*.gif",
    "*.ico",
    "*.jpg",
    "*.jpeg",
    "*.png",
    "*.avi",
    "*.wav",
    "*.webm",
    "*.eot",
    "*.otf",
    "*.ttf",
    "*.woff",
    "*.doc",
    "*.pdf",
    "*.zip",
    "*.tar.gz",
    "*.tar.bz2",
    "*.rar",
    "*.tar.xz",
    -- Cache
    ".sass-cache",
    "*/vendor/gems/*",
    "*/vendor/cache/*",
    "*/.bundle/*",
    "*.gem",
    -- Temp/System
    "*.*~",
    "*~ ",
    "*.swp",
    ".lock",
    ".DS_Store",
    "._*",
    "tags.lock",
}

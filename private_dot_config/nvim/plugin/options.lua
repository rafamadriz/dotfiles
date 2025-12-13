-- Timings
vim.opt.timeoutlen  = 1000 -- Time to wait for a keymap to complete
vim.opt.ttimeoutlen = 300 -- Time to wait for a key code sequence to complete
vim.opt.updatetime  = 400 -- If nothing is typed is this time, swap file will be written. Also used for 'CursorHold' autocommand

-- Window splitting
vim.opt.splitbelow = true -- Horizontal splits will be below
vim.opt.splitright = true -- Vertical splits will be to the right
vim.opt.splitkeep  = "screen" -- Keep the text on same line when resizing, closing...

-- Diff options
vim.opt.diffopt = {
    "internal", -- Use internal diff library (indent-heuristic). Ignored when diffexpr is set
    "filler", -- Show filler lines to keep text synchronized with window that has inserted lines in same place
    "closeoff", -- Disable diff mode when last window is closed
    "indent-heuristic", -- indent heuristic for internal diff library
    -- TODO: enable on 0.12
    -- "inline:char", -- Highlight inline differences character-wise
    "linematch:60", -- Align and mark changes between the most similar lines between buffers
    "algorithm:patience", -- Diff algorithm for internal diff engine
    "vertical", -- Start diff mode in vertical splits
}

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
vim.opt.scrolloff     = 2 -- Minimal number of lines to keep above/below the cursor
vim.opt.signcolumn    = "yes:2" -- show always, with fixed space for signs up to the given number (2)
vim.opt.termguicolors = true -- Enables 24-bit RGB color in the TUI
vim.opt.title         = true -- When on, the title of the window will be `filename [+= -] (path) - Nvim` or to value of titlestring if not empty
vim.opt.confirm       = true -- Save me from doing destructive things
vim.opt.showmode      = false -- When in insert, show mode in last line
vim.opt.pumheight     = 15 -- Maximum number of items to show in the popup menu
vim.opt.mouse         = "a" -- Enables mouse support
vim.opt.winborder     = "rounded" -- Default border style for floating windows

-- Completion
vim.opt.completeopt = "menuone,fuzzy,popup,noinsert"
vim.opt.wildoptions = "pum,fuzzy" -- A list of words that change how cmdline-completion is done.

-- Indentetion
vim.opt.wrap        = false
vim.opt.expandtab   = true -- Insert spaces instead of tabs on <Tab>
vim.opt.softtabstop = 4
vim.opt.shiftwidth  = 4
vim.opt.virtualedit = "block" -- Allow the cursor be positioned where there is no actual character

-- Numbers and lines
vim.opt.number     = true
vim.opt.cursorline = true

-- Match and Search
vim.opt.ignorecase = true
vim.opt.smartcase  = true

-- List Chars
vim.opt.list      = true
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
vim.opt.exrc           = true -- Enable project local configuration

-- Use rg as grep program
if vim.fn.executable "rg" > 0 then
    vim.opt.grepprg = [[rg --glob "!.git" --vimgrep --no-heading --smart-case --hidden]]
end
vim.opt.grepformat = "%f:%l:%c:%m"

-- Folds
vim.opt.foldlevelstart = 5
vim.opt.foldmethod     = "expr"
vim.opt.foldtext       = "" -- show original text with its syntax highlighting

-- BACKUP AND SWAP
vim.opt.swapfile = false
vim.opt.undofile = true

-- Lua version of `help fuzzy-file-picker`
---@param arg string
---@return string[]
_G.fuzzy_find = function(arg, _)
   local paths = vim.fn.globpath(".", "**", true, true)
   local fuzzy_filescache = vim.tbl_filter(function(path)
       if vim.fn.isdirectory(path) then
           return true
       end
       return false
   end, paths)

   fuzzy_filescache = vim.tbl_map(function(path) return vim.fn.fnamemodify(path, ":.") end, fuzzy_filescache)

   if not arg or arg == "" then
       return fuzzy_filescache
   end
   return vim.fn.matchfuzzy(fuzzy_filescache, arg)
end
vim.opt.findfunc = "v:lua.fuzzy_find"

-- Wild and file globbing stuff
vim.opt.wildignorecase = true -- Ignore case when completing file names and directories
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

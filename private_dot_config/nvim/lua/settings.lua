-- Timing {{{1
-----------------------------------------------------------------------------//
vim.opt.timeoutlen = 300
vim.opt.updatetime = 300
vim.opt.ttimeoutlen = 10
-----------------------------------------------------------------------------//
-- Window splitting and buffers {{{1
-----------------------------------------------------------------------------//
vim.opt.lazyredraw = true
vim.opt.hidden = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.switchbuf = "useopen,uselast"
vim.opt.fillchars = {
    vert = "▕", -- alternatives │
    fold = " ",
    eob = " ", -- suppress ~ at EndOfBuffer
    diff = "╱", -- alternatives = ⣿ ░ ─
    msgsep = "‾",
    foldopen = "▾",
    foldsep = "│",
    foldclose = "▸",
}
-----------------------------------------------------------------------------//
-- Diff {{{1
-----------------------------------------------------------------------------//
vim.opt.diffopt:append {
    "vertical",
    "iwhite",
    "hiddenoff",
    "foldcolumn:0",
    "context:4",
    "algorithm:histogram",
    "indent-heuristic",
}
-----------------------------------------------------------------------------//
-- Grep program {{{1
-----------------------------------------------------------------------------//
if as.executable "rg" then vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case" end
-----------------------------------------------------------------------------//
-- Display {{{1
-----------------------------------------------------------------------------//
vim.opt.colorcolumn = { 0 }
vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.scrolloff = 10
vim.opt.conceallevel = 0
vim.opt.signcolumn = "yes:1"
vim.opt.showbreak = [[↪ ]] -- Options include -> '…', '↳ ', '→','↪ '
vim.opt.showtabline = 1
vim.opt.termguicolors = true
vim.opt.guifont = "JetBrainsMono Nerd Font:h14"
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.title = true
vim.opt.number = true
vim.opt.numberwidth = 1
vim.opt.confirm = true -- make vim prompt to save before doing destructive things
vim.opt.fileencoding = "utf-8"
vim.opt.showmode = false
-----------------------------------------------------------------------------//
-- Formatoptions {{{1
-----------------------------------------------------------------------------//
vim.opt.formatoptions = {
    ["1"] = true, -- Don't break a line after a one-letter word.
    ["2"] = false, -- Use indent from 2nd line of a paragraph
    q = true, -- continue comments with gq"
    c = false, -- Insert current comment leader automatically
    r = false, -- Continue comments when pressing Enter
    n = true, -- Recognize numbered lists
    t = false, -- autowrap lines using text width value
    j = true, -- remove a comment leader when joining lines.
    -- Only break if the line was not longer than 'textwidth' when the insert
    -- started and only at a white character that has been entered during the
    -- current insert command.
    l = true,
}
-----------------------------------------------------------------------------//
-- List Chars {{{1
-----------------------------------------------------------------------------//
vim.opt.list = true
vim.opt.listchars = {
    trail = "•",
    -- eol = "↴",
    tab = "» ",
    extends = "❯",
    precedes = "❮",
    nbsp = "_",
    space = " ",
}
-----------------------------------------------------------------------------//
-- Indentation {{{1
-----------------------------------------------------------------------------//
local indent = 4
vim.opt.wrap = false
vim.opt.tabstop = 8
vim.opt.softtabstop = indent
vim.opt.shiftwidth = indent
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
-----------------------------------------------------------------------------//
-- Search and Complete {{{1
-----------------------------------------------------------------------------//
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "nosplit"
vim.opt.pumheight = 10
vim.opt.completeopt = "menuone,noinsert,noselect"
-----------------------------------------------------------------------------//
-- Utils {{{1
-----------------------------------------------------------------------------//
vim.opt.shortmess:append "c"
vim.opt.iskeyword:append "-"
vim.opt.path:append ".,**"
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
-----------------------------------------------------------------------------//
-- Folds {{{1
-----------------------------------------------------------------------------//
vim.opt.foldlevelstart = 5
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldmethod = "marker"
vim.opt.foldmethod = "expr" -- This is kinda buggy
vim.opt.foldnestmax = 3
vim.opt.foldtext =
    [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
-----------------------------------------------------------------------------//
-- Disable some builtin plugins {{{1
-----------------------------------------------------------------------------//
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_man = 1
vim.g.loaded_remote_plugins = 1
-- vim.g.do_filetype_lua = 1
-- vim.g.did_load_filetypes = 0
-- vim.g.did_load_filetypes = 1
-- vim.g.loaded_matchit = 1
-- vim.g.loaded_matchparen = 1
-----------------------------------------------------------------------------//
-- BACKUP AND SWAP {{{1
-----------------------------------------------------------------------------//
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
-----------------------------------------------------------------------------//
-- Wild and file globbing stuff in command mode {{{1
-----------------------------------------------------------------------------//
vim.opt.wildignorecase = true -- Ignore case when completing file names and directories
vim.opt.wildmode = "full"
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
-- }}}
-- vim:foldmethod=marker

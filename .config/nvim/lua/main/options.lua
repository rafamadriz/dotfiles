-- Timing {{{
vim.opt.timeoutlen = as._default_num(vim.g.neon_timeoutlen, 500)
vim.opt.updatetime = as._default_num(vim.g.neon_updatetime, 300)
vim.opt.ttimeoutlen = 10
-- }}}
-- Window splitting and buffers {{{
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
    foldclose = "▸"
}
-- }}}
-- Diff {{{
vim.opt.diffopt:append {
    "vertical",
    "iwhite",
    "hiddenoff",
    "foldcolumn:0",
    "context:4",
    "algorithm:histogram",
    "indent-heuristic"
}
-- }}}
-- Grep program {{{
if vim.fn.executable("rg") == 1 then
    vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
end
-- }}}
-- Display {{{
vim.opt.colorcolumn = {as._default_num(vim.g.neon_colorcolumn, 0)}
vim.opt.cmdheight = as._default_num(vim.g.neon_cmdheight, 2)
vim.opt.scrolloff = as._default_num(vim.g.neon_scrolloff, 10)
vim.opt.conceallevel = 0
vim.opt.signcolumn = "yes:1"
vim.opt.showbreak = [[↪ ]] -- Options include -> '…', '↳ ', '→','↪ '
vim.opt.showtabline = 2
vim.opt.termguicolors = true
vim.opt.guifont = "JetBrainsMono Nerd Font:h14"
vim.opt.relativenumber = as._default(vim.g.neon_relativenumber)
vim.opt.cursorline = as._default(vim.g.neon_cursorline)
vim.opt.title = true
vim.opt.number = true
vim.opt.numberwidth = 1
vim.opt.confirm = true -- make vim prompt to save before doing destructive things
vim.opt.fileencoding = "utf-8"
vim.opt.showmode = false
-- }}}
-- List Chars {{{
vim.opt.list = true
vim.opt.listchars = {trail = "•"}
if as._default(vim.g.neon_listchars, false) == true then
    vim.opt.listchars = {eol = "↴", tab = "│⋅", extends = "❯", precedes = "❮", nbsp = "_", space = "⋅"}
end
-- }}}
-- Indentation {{{
local indent = as._default_num(vim.g.neon_indent_size, 2)
vim.opt.wrap = as._default(vim.g.neon_word_wrap, false)
vim.opt.tabstop = 8
vim.opt.softtabstop = indent
vim.opt.shiftwidth = indent
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
-- }}}
-- Search and Complete {{{
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "nosplit"
vim.opt.pumheight = as._default_num(vim.g.neon_compe_items, 10)
vim.opt.completeopt = "menuone,noinsert,noselect"
-- }}}
-- Utils {{{
vim.opt.shortmess:append("c")
vim.opt.iskeyword:append("-")
vim.opt.path:append(".,**")
vim.opt.foldmethod = "marker"
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
-- }}}
-- BACKUP AND SWAP {{{
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
-- }}}
-- Wild and file globbing stuff in command mode {{{
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
    "tags.lock"
}
-- }}}

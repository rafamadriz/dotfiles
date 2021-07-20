-- Timing {{{1
-----------------------------------------------------------------------------//
vim.opt.timeoutlen = as._default_num(vim.g.code_timeoutlen, 300)
vim.opt.updatetime = as._default_num(vim.g.code_updatetime, 300)
vim.opt.ttimeoutlen = 10
-----------------------------------------------------------------------------//
-- Theme {{{1
-----------------------------------------------------------------------------//
vim.cmd("colorscheme " .. as.select_theme(vim.g.code_colorscheme))
-----------------------------------------------------------------------------//
-- Window splitting and buffers {{{1
-----------------------------------------------------------------------------//
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
if vim.fn.executable "rg" == 1 then
    vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
end
-----------------------------------------------------------------------------//
-- Display {{{1
-----------------------------------------------------------------------------//
vim.opt.colorcolumn = { as._default_num(vim.g.code_colorcolumn, 0) }
vim.opt.cmdheight = as._default_num(vim.g.code_cmdheight, 2)
vim.opt.scrolloff = as._default_num(vim.g.code_scrolloff, 10)
vim.opt.conceallevel = 0
vim.opt.signcolumn = "yes:1"
vim.opt.showbreak = [[↪ ]] -- Options include -> '…', '↳ ', '→','↪ '
vim.opt.showtabline = 2
vim.opt.termguicolors = true
vim.opt.guifont = "JetBrainsMono Nerd Font:h14"
vim.opt.relativenumber = as._default(vim.g.code_relativenumber)
vim.opt.cursorline = as._default(vim.g.code_cursorline)
vim.opt.title = true
vim.opt.number = true
vim.opt.numberwidth = 1
vim.opt.confirm = true -- make vim prompt to save before doing destructive things
vim.opt.fileencoding = "utf-8"
vim.opt.showmode = false
-----------------------------------------------------------------------------//
-- List Chars {{{1
-----------------------------------------------------------------------------//
if as._default(vim.g.code_listchars, false) == true then
    vim.opt.list = true
    vim.opt.listchars = {
        trail = "•",
        eol = "↴",
        tab = "» ",
        extends = "❯",
        precedes = "❮",
        nbsp = "_",
        space = " ",
    }
end
-----------------------------------------------------------------------------//
-- Indentation {{{1
-----------------------------------------------------------------------------//
local indent = as._default_num(vim.g.code_indent_size, 4)
vim.opt.wrap = as._default(vim.g.code_word_wrap, false)
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
vim.opt.pumheight = as._default_num(vim.g.code_compe_items, 10)
vim.opt.completeopt = "menuone,noinsert,noselect"
-----------------------------------------------------------------------------//
-- Utils {{{1
-----------------------------------------------------------------------------//
if as._default(vim.g.code_cursor_block, false) then
    vim.opt.guicursor = ""
end
vim.opt.shortmess:append "c"
vim.opt.iskeyword:append "-"
vim.opt.path:append ".,**"
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
-----------------------------------------------------------------------------//
-- Folds {{{1
-----------------------------------------------------------------------------//
vim.opt.foldlevelstart = 3
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldmethod = "marker"
-- vim.opt.foldmethod = "expr" -- This is kinda buggy
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
-----------------------------------------------------------------------------//
-- Autocommands {{{1
-----------------------------------------------------------------------------//
as.check_and_set(vim.g.code_trim_trailing_space, "BufWritePre", "*", [[%s/\s\+$//e]])
as.check_and_set(vim.g.code_trim_trailing_space, "BufWritePre", "*", [[%s/\n\+\%$//e]])
as.check_and_set(
    vim.g.code_highlight_yank,
    "TextYankPost",
    "*",
    'lua require"vim.highlight".on_yank{timeout = 250}'
)
as.check_and_set(
    vim.g.code_preserve_cursor,
    "BufReadPost",
    "*",
    [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
)
as.check_and_set(vim.g.code_format_on_save, "BufWritePost", "*", "silent FormatWrite")
-- }}}
-- vim:foldmethod=marker

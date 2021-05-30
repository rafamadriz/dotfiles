-- Global
as.opt("o", "timeoutlen", as._default_num(vim.g.neon_timeoutlen, 500))
as.opt("o", "pumheight", as._default_num(vim.g.neon_compe_items, 10))
as.opt("o", "updatetime", as._default_num(vim.g.neon_updatetime, 300))
as.opt("o", "scrolloff", as._default_num(vim.g.neon_scrolloff, 10))
as.opt("o", "cmdheight", as._default_num(vim.g.neon_cmdheight, 2))
as.opt("o", "incsearch", true)
as.opt("o", "ignorecase", true)
as.opt("o", "smartcase", true)
as.opt("o", "smarttab", true)
as.opt("o", "title", true)
as.opt("o", "backup", false)
as.opt("o", "writebackup", false)
as.opt("o", "clipboard", "unnamedplus")
as.opt("o", "showmode", false)
as.opt("o", "showtabline", 2)
as.opt("o", "termguicolors", true)
as.opt("o", "mouse", "a")
as.opt("o", "hidden", true)
as.opt("o", "splitbelow", true)
as.opt("o", "splitright", true)
as.opt("o", "inccommand", "nosplit")
as.opt("o", "completeopt", "menuone,noinsert,noselect")
as.opt("o", "guifont", "JetBrainsMono Nerd Font:h14")
if vim.fn.executable("rg") == 1 then
    as.opt("o", "grepprg", "rg --vimgrep --no-heading --smart-case")
end

-- Window
as.opt("w", "relativenumber", as._default(vim.g.neon_relativenumber))
as.opt("w", "cursorline", as._default(vim.g.neon_cursorline))
as.opt("w", "wrap", as._default(vim.g.neon_word_wrap, false))
as.opt("w", "number", true)
as.opt("w", "numberwidth", 1)
as.opt("w", "conceallevel", 0)
as.opt("w", "signcolumn", "yes:1")

-- Buffer
local indent = as._default_num(vim.g.neon_indent_size, 2)
as.opt("b", "tabstop", 8)
as.opt("b", "softtabstop", indent)
as.opt("b", "shiftwidth", indent)
as.opt("b", "expandtab", true)
as.opt("b", "autoindent", true)
as.opt("b", "smartindent", true)
as.opt("b", "swapfile", false)
as.opt("b", "undofile", true)
as.opt("b", "fileencoding", "utf-8")
as.opt("b", "syntax", "on")

-- Commands
local cmd = vim.cmd
cmd("set shortmess+=c")
cmd("set iskeyword+=-")
cmd("set path+=.,**")
cmd("filetype plugin on")
cmd("set list")
cmd("set listchars+=trail:•")
-- listchars
if as._default(vim.g.neon_listchars, false) == true then
    cmd("set listchars=eol:↴")
    cmd("set listchars+=tab:│⋅")
    cmd("set listchars+=extends:❯")
    cmd("set listchars+=precedes:❮")
    cmd("set listchars+=nbsp:_")
    cmd("set listchars+=space:⋅")
    cmd("set showbreak=↳⋅")
end

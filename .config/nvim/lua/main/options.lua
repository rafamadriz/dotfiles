local u = require("utils.core")
local cmd = vim.cmd

-- Global
u.opt("o", "incsearch", true)
u.opt("o", "ignorecase", true)
u.opt("o", "smartcase", true)
u.opt("o", "smarttab", true)
u.opt("o", "title", true)
u.opt("o", "backup", false)
u.opt("o", "writebackup", false)
u.opt("o", "clipboard", "unnamedplus")
u.opt("o", "showmode", false)
u.opt("o", "pumheight", Completion.items)
u.opt("o", "showtabline", 2)
u.opt("o", "updatetime", Opts.updatetime)
u.opt("o", "scrolloff", Opts.scrolloff)
u.opt("o", "cmdheight", 2)
u.opt("o", "termguicolors", true)
u.opt("o", "mouse", "a")
u.opt("o", "hidden", true)
u.opt("o", "splitbelow", true)
u.opt("o", "splitright", true)
u.opt("o", "timeoutlen", Opts.timeoutlen)
u.opt("o", "completeopt", "menuone,noinsert,noselect")

-- Window
u.opt("w", "relativenumber", Opts.relativenumber)
u.opt("w", "number", true)
u.opt("w", "numberwidth", 1)
u.opt("w", "wrap", Opts.wrap)
u.opt("w", "cursorline", Opts.cursorline)
u.opt("w", "conceallevel", 0)
u.opt("w", "signcolumn", "yes")

-- Buffer
local indent = Formatting.indent_size
u.opt("b", "tabstop", indent)
u.opt("b", "softtabstop", indent)
u.opt("b", "shiftwidth", indent)
u.opt("b", "expandtab", true)
u.opt("b", "autoindent", true)
u.opt("b", "smartindent", true)
u.opt("b", "swapfile", false)
u.opt("b", "undofile", true)
u.opt("b", "fileencoding", "utf-8")
u.opt("b", "syntax", "on")

-- Commands
cmd("set shortmess+=c")
cmd("set iskeyword+=-")
cmd("set path+=.,**")
cmd("filetype plugin on")
-- listchars
if Opts.listchars == true then
    cmd("set list")
    cmd("set listchars=eol:↴")
    cmd("set listchars+=tab:│⋅")
    cmd("set listchars+=trail:•")
    cmd("set listchars+=extends:❯")
    cmd("set listchars+=precedes:❮")
    cmd("set listchars+=nbsp:_")
    cmd("set listchars+=space:⋅")
    cmd("set showbreak=↳⋅")
end

local opt = as.opt

-- Global
opt("o", "incsearch", true)
opt("o", "ignorecase", true)
opt("o", "smartcase", true)
opt("o", "smarttab", true)
opt("o", "title", true)
opt("o", "backup", false)
opt("o", "writebackup", false)
opt("o", "clipboard", "unnamedplus")
opt("o", "showmode", false)
opt("o", "pumheight", Completion.items)
opt("o", "showtabline", 2)
opt("o", "updatetime", Opts.updatetime)
opt("o", "scrolloff", Opts.scrolloff)
opt("o", "cmdheight", 2)
opt("o", "termguicolors", true)
opt("o", "mouse", "a")
opt("o", "hidden", true)
opt("o", "splitbelow", true)
opt("o", "splitright", true)
opt("o", "inccommand", "nosplit")
opt("o", "timeoutlen", Opts.timeoutlen)
opt("o", "completeopt", "menuone,noinsert,noselect")

-- Window
opt("w", "relativenumber", Opts.relativenumber)
opt("w", "number", true)
opt("w", "numberwidth", 1)
opt("w", "wrap", Opts.wrap)
opt("w", "cursorline", Opts.cursorline)
opt("w", "conceallevel", 0)
opt("w", "signcolumn", "yes:1")

-- Buffer
local indent = Formatting.indent_size
opt("b", "tabstop", 8)
opt("b", "softtabstop", indent)
opt("b", "shiftwidth", indent)
opt("b", "expandtab", true)
opt("b", "autoindent", true)
opt("b", "smartindent", true)
opt("b", "swapfile", false)
opt("b", "undofile", true)
opt("b", "fileencoding", "utf-8")
opt("b", "syntax", "on")

-- Commands
local cmd = vim.cmd
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

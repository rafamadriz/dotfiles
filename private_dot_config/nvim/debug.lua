local temp_dir = vim.loop.os_getenv "TEMP" or "/tmp"
local install_dir = temp_dir .. "/lazy-nvim"

-- set stdpaths to use "/tmp/lazy-nvim"
for _, name in ipairs { "config", "data", "state", "cache" } do
    vim.env[("XDG_%s_HOME"):format(name:upper())] = install_dir .. "/" .. name
end

-- bootstrap lazy
local lazypath = install_dir .. "/plugins/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    }
end
vim.opt.runtimepath:prepend(lazypath)

-- install plugins
local plugins = {}

require("lazy").setup(plugins, {
    root = install_dir .. "/plugins",
})

vim.opt.termguicolors = true
vim.cmd.colorscheme "habamax"

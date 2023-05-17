local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

local opts = {
    defaults = {
        lazy = true,
    },
    lockfile = os.getenv "NVIMRC" .. "/lazy-lock.json",
}

require("lazy").setup("plugins", opts)

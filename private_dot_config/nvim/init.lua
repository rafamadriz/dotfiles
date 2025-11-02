-- Experimental cache lua modules `help vim.loader.enable`
-- https://github.com/neovim/neovim/pull/22668
if vim.loader then
    vim.loader.enable()
end

-- Space as leaderkey
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.keymap.set("v", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable some builtin plugins
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
-- vim.g.loaded_man = 1
vim.g.loaded_remote_plugins = 1
-- vim.g.loaded_matchit = 1
-- vim.g.loaded_matchparen = 1

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

local opts = {
    defaults = {
        lazy = true,
    },
    lockfile = os.getenv "HOME" .. "/.config/nvim/lazy-lock.json",
}

vim.keymap.set("n", "<leader>-", ":Lazy<CR>", { desc = "Lazy" })
require("lazy").setup({ { import = "plugins" }, { import = "plugins.debug" } }, opts)

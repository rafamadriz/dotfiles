vim.loader.enable()

-- Disable some builtin plugins
vim.g.loaded_gzip              = 1
vim.g.loaded_tar               = 1
vim.g.loaded_tarPlugin         = 1
vim.g.loaded_zip               = 1
vim.g.loaded_zipPlugin         = 1
vim.g.loaded_getscript         = 1
vim.g.loaded_getscriptPlugin   = 1
vim.g.loaded_2html_plugin      = 1
vim.g.loaded_netrw             = 1
vim.g.loaded_netrwPlugin       = 1
vim.g.loaded_netrwSettings     = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_remote_plugins    = 1

-- Enable undotree
-- vim.cmd.packadd "nvim.undotree"

-- Space as leaderkey
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.keymap.set("v", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

---@param plugin_name string
---@param opts? table
function _G.setup_plugin(plugin_name, opts)
    local ok, plugin = pcall(require, plugin_name)
    if ok then
        if not opts then
            opts = {}
        end
        plugin.setup(opts)
        return
    end
end

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
    lockfile = os.getenv "HOME" .. "/.config/nvim/lazy-lock.json",
}

vim.keymap.set("n", "<leader>-", ":Lazy<CR>", { desc = "Lazy" })
require("lazy").setup({
    { "https://github.com/neovim/nvim-lspconfig" },
    { "https://github.com/mason-org/mason.nvim" },
    { "https://github.com/nvim-mini/mini.nvim" },
    { "https://github.com/ibhagwan/fzf-lua" },
    { "https://github.com/stevearc/oil.nvim" },
    { "https://codeberg.org/andyg/leap.nvim" },
    { "https://github.com/stevearc/conform.nvim" },
    { "https://github.com/alker0/chezmoi.vim" },
    { "https://github.com/zk-org/zk-nvim" },
    { "https://github.com/catppuccin/nvim", name = "catppuccin" },
    { "https://github.com/windwp/nvim-ts-autotag" },
    { "https://github.com/folke/ts-comments.nvim" },
    { "https://github.com/RRethy/nvim-treesitter-endwise" },
    {
        "https://github.com/nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = "TSUpdate",
    },
    { "https://github.com/mbbill/undotree" }
}, opts)

vim.cmd.colorschem "catppuccin"

vim.g.undotree_WindowLayout = 4
vim.g.undotree_SplitWidth = 45
vim.g.undotree_SetFocusWhenToggle = 1

setup_plugin "mason"
setup_plugin "zk"
setup_plugin("fzf-lua", { "ivy" })
require "configs.mini"
require "configs.oil"
require "configs.leap"
require "configs.format"

-- Treesitter
require "configs.treesitter"
setup_plugin "ts-comments"
setup_plugin "nvim-ts-autotag"

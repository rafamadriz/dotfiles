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
vim.g.ftplugin_sql_omni_key    = "<C-o>"

-- Enable plugins
vim.cmd.packadd "nvim.undotree"
vim.cmd.packadd "cfilter"

-- Space as leaderkey
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.keymap.set("v", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable project local configuration
-- exrc is loaded before plugin files. So having this option in plugin/options.lua
-- doesn't work. check `:help startup` step 7 for exrc and step 11 for plugin files.
vim.opt.exrc = true

function vim.pack.setup(plugin_name, opts)
    local ok, plugin = pcall(require, plugin_name)
    if ok then
        plugin.setup(opts or {})
        return
    end
    vim.api.nvim_echo({ { plugin_name .. " Not found", "ErrorMsg" } }, true, {})
end

vim.pack.clean = function()
    local inactive = vim.iter(vim.pack.get())
        :filter(function(plugin) return not plugin.active end)
        :map(function(data) return data.spec.name end)
        :totable()

    vim.pack.del(inactive)
end

vim.pack.revert = function()
    local plugins = vim.iter(vim.pack.get())
        :map(function(data) return data.spec.name end)
        :totable()

    vim.pack.update(plugins, { offline = true, target = 'lockfile' })
end

function vim.pack.is_installed(plugin_name)
    local installed = vim.iter(vim.pack.get())
        :filter(function(plugin) return plugin.active end)
        :map(function(data) return data.spec.name end)
        :totable()

    return vim.tbl_contains(installed, plugin_name)
end

local hooks = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if name == "nvim-treesitter" and (kind == "install" or kind == "update" ) then
        if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
        vim.cmd("TSUpdate")
    end
end
vim.api.nvim_create_autocmd("PackChanged", { callback = hooks })

vim.pack.add {
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/nvim-mini/mini.nvim" },
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://codeberg.org/andyg/leap.nvim" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/alker0/chezmoi.vim" },
    { src = "https://github.com/zk-org/zk-nvim" },
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
    { src = "https://github.com/windwp/nvim-ts-autotag" },
    { src = "https://github.com/folke/ts-comments.nvim" },
    { src = "https://github.com/RRethy/nvim-treesitter-endwise" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
}

vim.cmd.colorscheme "catppuccin"

---@type snacks.Config
local snacks_config = {
    input     = { enabled = true },
    quickfile = { enabled = true },
    picker = {
        layout = "ivy_split",
        sources = {
            files = {
                hidden = true,
            },
            grep = {
                hidden = true,
            },
        }
    }
}

vim.pack.setup "mason"
vim.pack.setup "zk"
vim.pack.setup("snacks", snacks_config)
require "configs.mini"
require "configs.oil"
require "configs.leap"
require "configs.format"

-- Treesitter
require "configs.treesitter"
vim.pack.setup "ts-comments"
vim.pack.setup "nvim-ts-autotag"

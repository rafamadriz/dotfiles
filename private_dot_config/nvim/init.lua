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
vim.cmd.packadd "nvim.undotree"

-- Space as leaderkey
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.keymap.set("v", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

---@param plugin_name string
---@param opts? table
function vim.pack.setup_plugin(plugin_name, opts)
    local ok, plugin = pcall(require, plugin_name)
    if ok then
        if not opts then
            opts = {}
        end
        plugin.setup(opts)
        return
    end
end

vim.pack.clean = function()
    local inactive = vim.tbl_map(function(plugin)
        if not plugin.active then
            return plugin.spec.name
        end
    end, vim.pack.get())

    vim.pack.del(vim.tbl_values(inactive))
end

---@param plugin_name string
---@return boolean
function vim.pack.is_installed(plugin_name)
    local installed = {}
    for _, plugin in pairs(vim.pack.get()) do
        if plugin.active then
            table.insert(installed, plugin.spec.name)
        end
    end
    return vim.tbl_contains(installed, plugin_name)
end

local augroup = vim.api.nvim_create_augroup("Run callback after vim.pack update", { clear = false })
vim.api.nvim_create_autocmd("PackChanged", {
    group = augroup,
    pattern = "*",
    callback = function(e)
        local kind = e.data.kind
        local run = (e.data.spec.data or {}).run
        if kind == "update" and e.data.active then
            if type(run) == "function" then
                pcall(run, e.data)
            end
            if type(run) == "string" then
                vim.cmd(run)
            end
        end
    end,
})

vim.pack.add {
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/nvim-mini/mini.nvim" },
    { src = "https://github.com/ibhagwan/fzf-lua" },
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
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
}

vim.cmd.colorscheme "catppuccin"

vim.pack.setup_plugin "mason"
vim.pack.setup_plugin "zk"
vim.pack.setup_plugin("fzf-lua", { "ivy", grep = { hidden = true } })
require("fzf-lua").register_ui_select()
require "configs.mini"
require "configs.oil"
require "configs.leap"
require "configs.format"

-- Treesitter
require "configs.treesitter"
vim.pack.setup_plugin "ts-comments"
vim.pack.setup_plugin "nvim-ts-autotag"

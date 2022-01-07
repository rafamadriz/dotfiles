local M = {}

local cmd = vim.cmd
local fn = vim.fn

-- zen mode
local nu = { number = false, relativenumber = false }
local ata = { window = { width = 0.70, options = nu } }
local foc = { window = { width = 1 } }
local cen = { window = { width = 0.70 } }
local min = { window = { width = 1, options = nu } }

function M.ataraxis()
    cmd "PackerLoad zen-mode.nvim"
    require("zen-mode").toggle(ata)
end

function M.focus()
    cmd "PackerLoad zen-mode.nvim"
    require("zen-mode").toggle(foc)
end

function M.centered()
    cmd "PackerLoad zen-mode.nvim"
    require("zen-mode").toggle(cen)
end

function M.minimal()
    cmd "PackerLoad zen-mode.nvim"
    require("zen-mode").toggle(min)
end

return M

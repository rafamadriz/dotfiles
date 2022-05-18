local api = vim.api
local fn = vim.fn
----------------------------------------------------------------------------------------------------
-- Global Namespace
----------------------------------------------------------------------------------------------------
_G.as = {}

----------------------------------------------------------------------------------------------------
-- LSP
----------------------------------------------------------------------------------------------------
as.lsp = { borders = "rounded" }

----------------------------------------------------------------------------------------------------
-- Utils
----------------------------------------------------------------------------------------------------

---Check is command is executable
---@param cmd string
---return boolean
function as.executable(cmd)
    return fn.executable(cmd) > 0
end

----------------------------------------------------------------------------------------------------
-- Autocommand
----------------------------------------------------------------------------------------------------
---@class Autocommand
---@field description string
---@field event  string[] list of autocommand events
---@field pattern string[] list of autocommand patterns
---@field command string | function
---@field nested  boolean
---@field once    boolean
---@field buffer  number

---Create an autocommand
---returns the group ID so that it can be cleared or manipulated.
---@param name string
---@param commands Autocommand[]
---@return number
function as.augroup(name, commands)
    local id = api.nvim_create_augroup(name, { clear = true })
    for _, autocmd in ipairs(commands) do
        local is_callback = type(autocmd.command) == "function"
        api.nvim_create_autocmd(autocmd.event, {
            group = name,
            pattern = autocmd.pattern,
            desc = autocmd.desc,
            callback = is_callback and autocmd.command or nil,
            command = not is_callback and autocmd.command or nil,
            once = autocmd.once,
            nested = autocmd.nested,
            buffer = autocmd.buffer,
        })
    end
    return id
end

----------------------------------------------------------------------------------------------------
-- Mappings
----------------------------------------------------------------------------------------------------

-- source: https://github.com/akinsho/dotfiles/blob/main/.config/nvim/lua/as/globals.lua
-- credits: akinsho
---create a mapping function factory
---@param mode string
---@param o table
---@return fun(lhs: string, rhs: string|function, opts: table|nil) 'create a mapping'
local function make_mapper(mode, o)
    -- copy the opts table as extends will mutate the opts table passed in otherwise
    local parent_opts = vim.deepcopy(o)
    ---Create a mapping
    ---@param lhs string
    ---@param rhs string|function
    ---@param opts table
    return function(lhs, rhs, opts)
        -- If the label is all that was passed in, set the opts automagically
        opts = type(opts) == "string" and { desc = opts } or opts and vim.deepcopy(opts) or {}
        vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("keep", opts, parent_opts))
    end
end

local map_opts = { remap = true, silent = true }
local noremap_opts = { silent = true }

-- A recursive normal mapping
as.nmap = make_mapper("n", map_opts)
-- A recursive select mapping
as.xmap = make_mapper("x", map_opts)
-- A recursive insert mapping
as.imap = make_mapper("i", map_opts)
-- A recursive visual mapping
as.vmap = make_mapper("v", map_opts)
-- A recursive operator mapping
as.omap = make_mapper("o", map_opts)
-- A recursive terminal mapping
as.tmap = make_mapper("t", map_opts)
-- A recursive visual & select mapping
as.smap = make_mapper("s", map_opts)
-- A recursive commandline mapping
as.cmap = make_mapper("c", { remap = true, silent = false })
-- A non recursive normal mapping
as.nnoremap = make_mapper("n", noremap_opts)
-- A non recursive select mapping
as.xnoremap = make_mapper("x", noremap_opts)
-- A non recursive visual mapping
as.vnoremap = make_mapper("v", noremap_opts)
-- A non recursive insert mapping
as.inoremap = make_mapper("i", noremap_opts)
-- A non recursive operator mapping
as.onoremap = make_mapper("o", noremap_opts)
-- A non recursive terminal mapping
as.tnoremap = make_mapper("t", noremap_opts)
-- A non recursive visual & select mapping
as.snoremap = make_mapper("s", noremap_opts)
-- A non recursive commandline mapping
as.cnoremap = make_mapper("c", { silent = false })

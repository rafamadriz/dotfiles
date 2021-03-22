local utils = {}
vim = vim
local cmd = vim.cmd
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

-- options
function utils.opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= 'o' then scopes['o'][key] = value end
end

-- autocommands
function utils.create_augroup(autocmds, name)
    cmd('augroup ' .. name)
    cmd('autocmd!')
    for _, autocmd in ipairs(autocmds) do
        cmd('autocmd ' .. table.concat(autocmd, ' '))
    end
    cmd('augroup END')
end

-- mappings
function utils.map(mode, key, result, opts)
    local options = { noremap = true, silent = true }
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, key, result, options)
end

return utils

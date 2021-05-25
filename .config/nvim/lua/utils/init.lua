-- idea from https://github.com/akinsho/dotfiles
--- store all callbacks in one global table so they are able to survive re-requiring this file
_AsGlobalCallbacks = _AsGlobalCallbacks or {}
DATA_PATH = vim.fn.stdpath("data")

_G.as = {
    _store = _AsGlobalCallbacks
}

local fn = vim.fn
local cmd = vim.cmd
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

-- options
function as.opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= "o" then
        scopes["o"][key] = value
    end
end

-- mappings
function as.map(mode, key, result, opts)
    local options = {noremap = true, silent = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, key, result, options)
end

-- autocommands
function as.nvim_set_au(au_type, where, dispatch)
    vim.cmd(string.format("au! %s %s %s", au_type, where, dispatch))
end

-- default option
function as._default(option, boolean)
    if option == true or option == nil and boolean == nil then
        return true
    elseif option == false and boolean == nil then
        return false
    end
    return boolean
end

function as._default_num(option, int)
    if option == nil or not tonumber(option) or option <= 0 then
        return int
    end
    return option
end

function as._lsp_auto(server)
    for i, v in pairs(LSP.autostart) do
        if server == i then
            return v
        end
    end
    return false
end

function as._compe(source, component)
    if as._default(source) == true then
        return component
    end
    return false
end

function as.select_theme(theme)
    local all_colors = vim.fn.getcompletion("", "color")
    local default = "neon"
    for _, v in pairs(all_colors) do
        if theme == v then
            return theme
        end
    end
    for _, v in pairs(all_colors) do
        if default == v then
            return default
        end
    end
    return "default"
end

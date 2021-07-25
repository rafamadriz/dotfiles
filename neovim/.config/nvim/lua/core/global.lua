--- store all callbacks in one global table so they are able to survive re-requiring this file
_AsGlobalCallbacks = _AsGlobalCallbacks or {}
DATA_PATH = vim.fn.stdpath "data"

_G.as = {
    _store = _AsGlobalCallbacks,
}

-- create global variables for config file
local ok, config = pcall(require, "config")
if ok then
    for opt, val in pairs(config) do
        local key = "code_" .. opt
        if not vim.g[key] then
            vim.g[key] = val
        end
    end
end

-- mappings
function as.map(mode, key, result, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, key, result, options)
end

-- autocommands
function as.nvim_set_au(au_type, where, dispatch)
    vim.cmd(string.format("au! %s %s %s", au_type, where, dispatch))
end

function as.check_and_set(option, au_type, where, dispatch, boolean)
    if as._default(option, boolean) == true then
        as.nvim_set_au(au_type, where, dispatch)
    end
end

-- inspect
function as.dump(...)
    local objects = vim.tbl_map(vim.inspect, { ... })
    print(unpack(objects))
    return ...
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
    local blacklist = vim.g.code_lsp_autostart_blacklist
    if blacklist == nil or #blacklist < 1 then
        return true
    end
    for _, v in pairs(blacklist) do
        if server == v then
            return false
        end
    end
    return true
end

function as._lsp_borders(value)
    local opt = { "single", "double" }
    if value ~= nil then
        for _, v in pairs(opt) do
            if value == v then
                return v
            end
        end
    end
    return nil
end

function as._compe(source, component)
    local blacklist = vim.g.code_compe_sources_blacklist
    if blacklist ~= nil then
        for _, v in pairs(blacklist) do
            if source == v then
                return false
            end
        end
    end
    return component
end

function as.select_theme(theme)
    local all_colors = vim.fn.getcompletion("", "color")
    local default = "neon"
    local fmt = string.format
    for _, v in pairs(all_colors) do
        if theme == v then
            return theme
        end
    end
    for _, v in pairs(all_colors) do
        if default == v then
            print(fmt([[colorscheme "%s" doesn't exist, using default]], theme))
            return default
        end
    end
    return "default"
end

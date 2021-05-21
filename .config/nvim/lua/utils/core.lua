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

-- Terminal
local Terminal = require("toggleterm.terminal").Terminal

local lazygit =
    Terminal:new(
    {
        cmd = "lazygit",
        direction = "float",
        hidden = true
    }
)

function as.lazygit_toggle()
    lazygit:toggle()
end

-- Telescope
function as.search_nvim()
    require("telescope.builtin").find_files(
        {
            prompt_title = "Neovim Config",
            cwd = "$HOME/.config/nvim/lua"
        }
    )
end

-- LSP
local t = require("telescope.themes")
local a = require("telescope.builtin")
local options = {width = 55, results_height = 10}
local theme = t.get_dropdown(options)

function as.code_actions()
    a.lsp_code_actions(theme)
end
function as.range_code_actions()
    a.lsp_range_code_actions(theme)
end

local function preview_location_callback(_, _, result)
    if result == nil or vim.tbl_isempty(result) then
        return nil
    end
    vim.lsp.util.preview_location(result[1])
end

function as.PeekDefinition()
    local params = vim.lsp.util.make_position_params()
    return vim.lsp.buf_request(0, "textDocument/definition", params, preview_location_callback)
end

-- zen mode
cmd [[packadd zen-mode.nvim]]
local zen = require("zen-mode")
local nu = {number = false, relativenumber = false}
local min = {window = {width = 1, options = nu}}
local ata = {window = {width = .75, options = nu}}

function as.minimal()
    zen.toggle(min)
end

function as.ataraxis()
    zen.toggle(ata)
end

-- Reload
-- NOTE: taken from https://github.com/famiu/nvim-reload
-- ======================================
local Path = require("plenary.path")
local scan_dir = require("plenary.scandir").scan_dir

-- Paths to unload Lua modules from
as.lua_reload_dirs = {fn.stdpath("config")}

-- Paths to reload Vim files from
as.vim_reload_dirs = {fn.stdpath("config"), fn.stdpath("data") .. "/site/pack/*/start/*"}

-- External files outside the runtimepaths to source
as.files_reload_external = {}

-- External Lua modules outside the runtimepaths to unload
as.modules_reload_external = {}

-- Pre-reload hook
as.pre_reload_hook = nil
as.post_reload_hook = nil

local viml_subdirs = {
    "compiler",
    "doc",
    "keymap",
    "syntax",
    "plugin"
}

-- Escape lua string
local function escape_str(str)
    local patterns_to_escape = {
        "%^",
        "%$",
        "%(",
        "%)",
        "%%",
        "%.",
        "%[",
        "%]",
        "%*",
        "%+",
        "%-",
        "%?"
    }

    return string.gsub(str, string.format("([%s])", table.concat(patterns_to_escape)), "%%%1")
end

-- Check if path exists
local function path_exists(path)
    return Path:new(path):exists()
end

local function get_runtime_files_in_path(runtimepath)
    -- Ignore opt plugins
    if string.match(runtimepath, "/site/pack/.-/opt") then
        return {}
    end

    local runtime_files = {}

    -- Search each subdirectory listed listed in viml_subdirs of runtimepath for files
    for _, subdir in ipairs(viml_subdirs) do
        local viml_path = string.format("%s/%s", runtimepath, subdir)

        if path_exists(viml_path) then
            local files = scan_dir(viml_path, {search_pattern = "%.n?vim$", hidden = true})

            for _, file in ipairs(files) do
                runtime_files[#runtime_files + 1] = file
            end
        end
    end

    return runtime_files
end

local function get_lua_modules_in_path(runtimepath)
    local luapath = string.format("%s/lua", runtimepath)

    if not path_exists(luapath) then
        return {}
    end

    -- Search lua directory of runtimepath for modules
    local modules = scan_dir(luapath, {search_pattern = "%.lua$", hidden = true})

    for i, module in ipairs(modules) do
        -- asemove runtimepath and file extension from module path
        module = string.match(module, string.format("%s/(.*)%%.lua", escape_str(luapath)))

        -- Changes slash in path to dot to follow lua module format
        module = string.gsub(module, "/", ".")

        -- If module ends with '.init', remove it.
        module = string.gsub(module, "%.init$", "")

        -- Override previous value with new value
        modules[i] = module
    end

    return modules
end

-- aseload all start plugins
local function reload_runtime_files()
    -- Search each runtime path for files
    for _, runtimepath_suffix in ipairs(as.vim_reload_dirs) do
        -- Expand the globs and get the result as a list
        local paths = fn.glob(runtimepath_suffix, 0, 1)

        for _, path in ipairs(paths) do
            local runtime_files = get_runtime_files_in_path(path)

            for _, file in ipairs(runtime_files) do
                cmd("source " .. file)
            end
        end
    end

    for _, file in ipairs(as.files_reload_external) do
        cmd("source " .. file)
    end
end

-- Unload all loaded Lua modules
local function unload_lua_modules()
    -- Search each runtime path for modules
    for _, runtimepath_suffix in ipairs(as.lua_reload_dirs) do
        local paths = fn.glob(runtimepath_suffix, 0, 1)

        for _, path in ipairs(paths) do
            local modules = get_lua_modules_in_path(path)

            for _, module in ipairs(modules) do
                package.loaded[module] = nil
            end
        end
    end

    for _, module in ipairs(as.modules_reload_external) do
        package.loaded[module] = nil
    end
end

-- aseload Vim configuration
function as.Reload()
    -- asun pre-reload hook
    if type(as.pre_reload_hook) == "function" then
        as.pre_reload_hook()
    end

    -- Clear highlights
    cmd("highlight clear")

    -- Stop LSP if it's configured
    if fn.exists(":LspStop") ~= 0 then
        cmd("LspStop")
    end

    -- Unload all already loaded modules
    unload_lua_modules()

    -- Source init file
    if string.match(fn.expand("$MYVIMRC"), "%.lua$") then
        cmd("luafile $MYVIMRC")
    else
        cmd("source $MYVIMRC")
    end

    -- aseload start plugins
    reload_runtime_files()

    -- asun post-reload hook
    if type(as.post_reload_hook) == "function" then
        as.post_reload_hook()
    end
end
as.post_reload_hook = function()
    require("feline").reset_highlights()
end

local M = {}

local cmd = vim.cmd
local fn = vim.fn

-- automatically creates missing directories when saving a file
function M.mkdir()
    local dir = fn.expand "%:p:h"

    if fn.isdirectory(dir) == 0 then
        fn.mkdir(dir, "p")
    end
end

-- delete buffers and preserve window layout.
M.delete_buffer = function()
    local buflisted = fn.getbufinfo { buflisted = 1 }
    local cur_winnr, cur_bufnr = fn.winnr(), fn.bufnr()
    if #buflisted < 2 then
        cmd "confirm qall"
        return
    end
    for _, winid in ipairs(fn.getbufinfo(cur_bufnr)[1].windows) do
        cmd(string.format("%d wincmd w", fn.win_id2win(winid)))
        cmd(cur_bufnr == buflisted[#buflisted].bufnr and "bp" or "bn")
    end
    cmd(string.format("%d wincmd w", cur_winnr))
    local is_terminal = fn.getbufvar(cur_bufnr, "&buftype") == "terminal"
    cmd(is_terminal and "bd! #" or "silent! confirm bd #")
end

-- tmux like <C-b>z: focus on one buffer in extra tab
-- put current window in new tab with cursor restored
M.buf_to_tab = function()
    -- skip if there is only one window open
    if vim.tbl_count(vim.api.nvim_tabpage_list_wins(0)) == 1 then
        print "Cannot expand single buffer"
        return
    end

    local buf = vim.api.nvim_get_current_buf()
    local view = fn.winsaveview()
    -- note: tabedit % does not properly work with terminal buffer
    cmd [[tabedit]]
    -- set buffer and remove one opened by tabedit
    local tabedit_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_buf_delete(tabedit_buf, { force = true })
    -- restore original view
    fn.winrestview(view)
end

-- expand or minimize current buffer in "actual" direction
-- this is useful as mapping ":resize 2" stand-alone might otherwise not be in
-- the right direction if mapped to ctrl-leftarrow or something related use
M.resize = function(vertical, margin)
    local cur_win = vim.api.nvim_get_current_win()
    -- go (possibly) right
    cmd(string.format("wincmd %s", vertical and "l" or "j"))
    local new_win = vim.api.nvim_get_current_win()

    -- determine direction cond on increase and existing right-hand buffer
    local not_last = not (cur_win == new_win)
    local sign = margin > 0
    -- go to previous window if required otherwise flip sign
    if not_last == true then
        cmd [[wincmd p]]
    else
        sign = not sign
    end

    sign = sign and "+" or "-"
    local dir = vertical and "vertical " or ""
    local _cmd = dir .. "resize " .. sign .. math.abs(margin) .. "<CR>"
    cmd(_cmd)
end

-- From https://github.com/famiu/nvim-reload
local Path = require "plenary.path"
local scan_dir = require("plenary.scandir").scan_dir

-- Paths to unload Lua modules from
M.lua_reload_dirs = { fn.stdpath "config" }

-- Paths to reload Vim files from
M.vim_reload_dirs = { fn.stdpath "config", fn.stdpath "data" .. "/site/pack/*/start/*" }

-- External files outside the runtimepaths to source
M.files_reload_external = {}

-- External Lua modules outside the runtimepaths to unload
M.modules_reload_external = { "packer" }

-- Pre-reload hook
M.pre_reload_hook = nil
M.post_reload_hook = nil

local viml_subdirs = {
    "compiler",
    "doc",
    "keymap",
    "syntax",
    "plugin",
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
        "%?",
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
            local files = scan_dir(viml_path, { search_pattern = "%.n?vim$", hidden = true })

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
    local modules = scan_dir(luapath, { search_pattern = "%.lua$", hidden = true })

    for i, module in ipairs(modules) do
        -- Remove runtimepath and file extension from module path
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

-- Reload all start plugins
local function reload_runtime_files()
    -- Search each runtime path for files
    for _, runtimepath_suffix in ipairs(M.vim_reload_dirs) do
        -- Expand the globs and get the result as a list
        local paths = fn.glob(runtimepath_suffix, 0, 1)

        for _, path in ipairs(paths) do
            local runtime_files = get_runtime_files_in_path(path)

            for _, file in ipairs(runtime_files) do
                cmd("source " .. file)
            end
        end
    end

    for _, file in ipairs(M.files_reload_external) do
        cmd("source " .. file)
    end
end

-- Unload all loaded Lua modules
local function unload_lua_modules()
    -- Search each runtime path for modules
    for _, runtimepath_suffix in ipairs(M.lua_reload_dirs) do
        local paths = fn.glob(runtimepath_suffix, 0, 1)

        for _, path in ipairs(paths) do
            local modules = get_lua_modules_in_path(path)

            for _, module in ipairs(modules) do
                package.loaded[module] = nil
            end
        end
    end

    for _, module in ipairs(M.modules_reload_external) do
        package.loaded[module] = nil
    end
end

-- Reload Vim configuration
function M.Reload()
    -- Run pre-reload hook
    if type(M.pre_reload_hook) == "function" then
        M.pre_reload_hook()
    end

    -- Clear highlights
    cmd "highlight clear"

    -- Stop LSP if it's configured
    if fn.exists ":LspStop" ~= 0 then
        cmd "LspStop"
    end

    -- Unload all already loaded modules
    unload_lua_modules()

    -- Source init file
    if string.match(fn.expand "$MYVIMRC", "%.lua$") then
        cmd "luafile $MYVIMRC"
    else
        cmd "source $MYVIMRC"
    end

    -- Reload start plugins
    reload_runtime_files()

    -- Run post-reload hook
    if type(M.post_reload_hook) == "function" then
        M.post_reload_hook()
    end
end
M.post_reload_hook = function()
    cmd [[packadd packer.nvim]]
    require("feline").reset_highlights()
end

return M

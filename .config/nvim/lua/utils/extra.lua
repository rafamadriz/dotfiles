local M = {}

local cmd = vim.cmd
local fn = vim.fn

-- Taken from https://www.reddit.com/r/neovim/comments/gyb077/nvimlsp_peek_defination_javascript_ttserver/
function M.preview_location(location, context, before_context)
    -- location may be LocationLink or Location (more useful for the former)
    context = context or 15
    before_context = before_context or 0
    local uri = location.targetUri or location.uri
    if uri == nil then
        return
    end
    local bufnr = vim.uri_to_bufnr(uri)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
        fn.bufload(bufnr)
    end
    local borders = as._lsp_borders(vim.g.neon_lsp_window_borders)
    local range = location.targetRange or location.range
    local contents = vim.api.nvim_buf_get_lines(
        bufnr,
        range.start.line - before_context,
        range["end"].line + 1 + context,
        false
    )
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    return vim.lsp.util.open_floating_preview(contents, filetype, { border = borders })
end

function M.preview_location_callback(_, method, result)
    local context = 15
    if result == nil or vim.tbl_isempty(result) then
        print("No location found: " .. method)
        return nil
    end
    if vim.tbl_islist(result) then
        M.floating_buf, M.floating_win = M.preview_location(result[1], context)
    else
        M.floating_buf, M.floating_win = M.preview_location(result, context)
    end
end

function M.PeekDefinition()
    if vim.tbl_contains(vim.api.nvim_list_wins(), M.floating_win) then
        vim.api.nvim_set_current_win(M.floating_win)
    else
        local params = vim.lsp.util.make_position_params()
        return vim.lsp.buf_request(
            0,
            "textDocument/definition",
            params,
            M.preview_location_callback
        )
    end
end

-- zen mode
local nu = { number = false, relativenumber = false }
local ata = { window = { width = 0.70, options = nu } }
local foc = { window = { width = 1 } }
local cen = { window = { width = 0.70 } }
local min = { window = { width = 1, options = nu } }

function M.ataraxis()
    cmd "packadd zen-mode.nvim"
    require("zen-mode").toggle(ata)
end

function M.focus()
    cmd "packadd zen-mode.nvim"
    require("zen-mode").toggle(foc)
end

function M.centered()
    cmd "packadd zen-mode.nvim"
    require("zen-mode").toggle(cen)
end

function M.minimal()
    cmd "packadd zen-mode.nvim"
    require("zen-mode").toggle(min)
end

-- automatically creates missing directories when saving a file
function M.mkdir()
    local dir = fn.expand "%:p:h"

    if fn.isdirectory(dir) == 0 then
        fn.mkdir(dir, "p")
    end
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

local coerce = require "coerce"

local convert_names = {
    ["snake_case"] = coerce.to_snake_case,
    ["camelCase"] = coerce.to_camel_case,
    ["PascalCase"] = coerce.to_pascal_case,
    ["UPPER_CASE"] = coerce.to_uppercase,
    ["kebab-case"] = coerce.to_kebab_case,
    ["dot.case"] = coerce.to_dot_case,
}

vim.api.nvim_create_user_command("To", function(opts)
    local cword = coerce.get_cword_position(opts.bang)
    local position = {
        start_row = cword.line + 1,
        start_col = cword.start_col,
        end_row = cword.line + 1,
        end_col = cword.end_col,
    }

    local mode = ""
    if opts.range > 0 then
        local start_pos = vim.fn.getpos "'<"
        local end_pos = vim.fn.getpos "'>"
        mode = vim.fn.visualmode()
        position = {
            start_row = start_pos[2],
            start_col = start_pos[3],
            end_row = end_pos[2],
            end_col = end_pos[3],
        }
    end

    local arg = opts.fargs[1]:gsub(" ", "")
    for key, to_case in pairs(convert_names) do
        if arg == key then
            coerce.handle_coerce(to_case, position, mode, opts.bang)
        end
    end
end, {
    bang = true,
    range = true,
    nargs = 1,
    complete = function()
        local completion = {}
        for key, _ in pairs(convert_names) do
            table.insert(completion, key)
        end
        return completion
    end,
})

-- Implementation of dot repeat from:
-- https://gist.github.com/kylechui/a5c1258cd2d86755f97b10fc921315c3
_G.cached_handle_coerce = nil

_G.handle_coerce = function()
    if not _G.cached_handle_coerce then return end

    local cword = coerce.get_cword_position(false)
    local position = {
        start_row = cword.line + 1,
        start_col = cword.start_col,
        end_row = cword.line + 1,
        end_col = cword.end_col,
    }

    coerce.handle_coerce(_G.cached_handle_coerce, position, "", false)
end

local coerce_to_uppercase = function()
    if vim.api.nvim_get_mode().mode == "v" or vim.api.nvim_get_mode().mode == "V" then
        return ":To UPPER_CASE<CR>"
    end
    _G.cached_handle_coerce = coerce.to_uppercase
    vim.o.operatorfunc = "v:lua.handle_coerce"
    return "g@l"
end

local coerce_to_snake_case = function()
    if vim.api.nvim_get_mode().mode == "v" or vim.api.nvim_get_mode().mode == "V" then
        return ":To snake_case<CR>"
    end
    _G.cached_handle_coerce = coerce.to_snake_case
    vim.o.operatorfunc = "v:lua.handle_coerce"
    return "g@l"
end

local coerce_to_camel_case = function()
    if vim.api.nvim_get_mode().mode == "v" or vim.api.nvim_get_mode().mode == "V" then
        return ":To camelCase<CR>"
    end
    _G.cached_handle_coerce = coerce.to_camel_case
    vim.o.operatorfunc = "v:lua.handle_coerce"
    return "g@l"
end

local coerce_to_pascal_case = function()
    if vim.api.nvim_get_mode().mode == "v" or vim.api.nvim_get_mode().mode == "V" then
        return ":To PascalCase<CR>"
    end
    _G.cached_handle_coerce = coerce.to_pascal_case
    vim.o.operatorfunc = "v:lua.handle_coerce"
    return "g@l"
end

local coerce_to_dot_case = function()
    if vim.api.nvim_get_mode().mode == "v" or vim.api.nvim_get_mode().mode == "V" then
        return ":To dot.case<CR>"
    end
    _G.cached_handle_coerce = coerce.to_dot_case
    vim.o.operatorfunc = "v:lua.handle_coerce"
    return "g@l"
end

local coerce_to_kebab_case = function()
    if vim.api.nvim_get_mode().mode == "v" or vim.api.nvim_get_mode().mode == "V" then
        return ":To kebab-case<CR>"
    end
    _G.cached_handle_coerce = coerce.to_kebab_case
    vim.o.operatorfunc = "v:lua.handle_coerce"
    return "g@l"
end

vim.keymap.set({ "v", "n" }, "cru", coerce_to_uppercase,   { expr = true })
vim.keymap.set({ "v", "n" }, "crs", coerce_to_snake_case,  { expr = true })
vim.keymap.set({ "v", "n" }, "crc", coerce_to_camel_case,  { expr = true })
vim.keymap.set({ "v", "n" }, "crp", coerce_to_pascal_case, { expr = true })
vim.keymap.set({ "v", "n" }, "cr.", coerce_to_dot_case,    { expr = true })
vim.keymap.set({ "v", "n" }, "crk", coerce_to_kebab_case,  { expr = true })

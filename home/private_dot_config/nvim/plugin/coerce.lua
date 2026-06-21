local coerce = require "coerce"

local convert_names = {
    { "crs", "snake_case", coerce.to_snake_case },
    { "crc", "camelCase" , coerce.to_camel_case },
    { "crp", "PascalCase", coerce.to_pascal_case },
    { "cru", "UPPER_CASE", coerce.to_uppercase },
    { "cr-", "kebab-case", coerce.to_kebab_case },
    { "cr.", "dot.case"  , coerce.to_dot_case },
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
    for _, m in pairs(convert_names) do
        local cmd_name, to_case = m[2], m[3]
        if arg == cmd_name then
            coerce.handle_coerce(to_case, position, mode, opts.bang)
        end
    end
end, {
    bang  = true,
    range = true,
    nargs = 1,
    complete = function()
        local completion = {}
        for _, m in pairs(convert_names) do
            local cmd_name = m[2]
            table.insert(completion, cmd_name)
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
        start_row  = cword.line + 1,
        start_col  = cword.start_col,
        end_row    = cword.line + 1,
        end_col    = cword.end_col,
    }

    coerce.handle_coerce(_G.cached_handle_coerce, position, "", false)
end

local make_coerce_map = function(cmd_name, to_case)
    return function()
        if vim.api.nvim_get_mode().mode == "v" or vim.api.nvim_get_mode().mode == "V" then
            return ":To " .. cmd_name .. "<CR>"
        end
        _G.cached_handle_coerce = to_case
        vim.o.operatorfunc = "v:lua.handle_coerce"
        return "g@l"
    end
end

for _, m in pairs(convert_names) do
    local keymap, cmd_name, to_case = m[1], m[2], m[3]
    vim.keymap.set({ "v", "n" }, keymap, make_coerce_map(cmd_name, to_case), { expr = true, desc = cmd_name })
end

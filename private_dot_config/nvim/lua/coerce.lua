---@param str string
---@return boolean
local function lower_before_upper(str)
    return string.match(str, "%l%u")
end

---@param str string
---@return boolean
local function dot_before_letter(str)
    return string.match(str, "%.%a")
end

---@param str string
---@return boolean
local function underscore_before_letter(str)
    return string.match(str, "_%a")
end

---@param str string
---@return boolean
local function dash_before_letter(str)
    return string.match(str, "-%a")
end

---@param str string
---@return boolean
local function first_letter_is_upper(str)
    return str:find("%u") == 1
end

---@param char_to_add string
---@param str string string in which to add char
---@return string
local function add_char_before_upper(char_to_add, str)
    local str_with_added_char, _ = string.gsub(str, "(%l)(%u)", "%1" .. char_to_add .. "%2")
    return str_with_added_char
end

---@param char_to_add string
---@param char_to_replace string
---@param str string string in which to add char
---@return string
local function replace_char_with(char_to_replace, char_to_add, str)
    if char_to_replace == "." then char_to_replace = "%." end
    local str_with_replaced_char, _ = string.gsub(str, char_to_replace .. "(%a)", char_to_add .. "%1")
    return str_with_replaced_char
end

---@param char_to_remove string
---@param str string string in which to add char
---@return string
local function remove_char_uppercase_after(char_to_remove, str)
    if char_to_remove == "." then char_to_remove = "%." end
    local str_with_removed_char_uppercase_after, _ = string.gsub(str:lower(),
        char_to_remove .. "(%a)",
        function(char)
            return char:upper()
        end)
    return str_with_removed_char_uppercase_after
end

local M = {}

---@param str string
---@return string
M.to_snake_case = function(str)
    local result = str

    if lower_before_upper(result) then
        result = add_char_before_upper("_", result)
    end

    if dot_before_letter(result) then
        result = replace_char_with(".", "_", result)
    end

    if dash_before_letter(result) then
        result = replace_char_with("-", "_", result)
    end

    return result:lower()
end

---@param str string
---@return string
M.to_camel_case = function(str)
    local result = str

    if dot_before_letter(result) then
        result = remove_char_uppercase_after(".", result)
    end

    if dash_before_letter(result) then
        result = remove_char_uppercase_after("-", result)
    end

    if underscore_before_letter(result) then
        result = remove_char_uppercase_after("_", result)
    end

    if first_letter_is_upper(result) then
        local first_letter_to_lower = string.gsub(result, "%u", function(c) return c:lower() end, 1)
        result =  first_letter_to_lower
    end

    return result
end

---@param str string
---@return string
M.to_pascal_case = function(str)
    local to_pascal = M.to_camel_case(str)

    if not first_letter_is_upper(to_pascal) then
        to_pascal = string.gsub(to_pascal, "%l", function(c) return c:upper() end, 1)
    end

    return to_pascal
end

---@param str string
---@return string
M.to_uppercase = function(str)
    local result = str

    if dot_before_letter(result) then
        result = replace_char_with(".", "_", result)
    end

    if dash_before_letter(result) then
        result = replace_char_with("-", "_", result)
    end

    if lower_before_upper(result) then
        result = add_char_before_upper("_", result)
    end

    return result:upper()
end

---@param str string
---@return string
M.to_kebab_case = function(str)
    local result = str

    if dot_before_letter(result) then
        result = replace_char_with(".", "-", result)
    end

    if underscore_before_letter(result) then
        result = replace_char_with("_", "-", result)
    end

    if lower_before_upper(result) then
        result = add_char_before_upper("-", result)
    end

    return result:lower()
end

---@param str string
---@return string
M.to_dot_case = function(str)
    local result = str

    if dash_before_letter(result) then
        result = replace_char_with("-", ".", result)
    end

    if underscore_before_letter(result) then
        result = replace_char_with("_", ".", result)
    end

    if lower_before_upper(result) then
        result = add_char_before_upper(".", result)
    end

    return result:lower()
end

---@class Position
---@field start_row number -- First line index
---@field end_row number  -- Starting column (byte offset) on first line
---@field start_col number -- Last line index, inclusive
---@field end_col number  -- Ending column (byte offset) on last line, exclusive

---@param position Position
---@param text string[]
---@param buf number
local function set_text(buf, position, text)
    vim.api.nvim_buf_set_text(buf,
        position.start_row - 1,
        position.start_col - 1,
        position.end_row - 1,
        position.end_col,
        text)
end

---@param cWORD boolean -- true for cWORD or false for cword, see :help <cword>
M.get_cword_position = function(cWORD)
    local pos = vim.api.nvim_win_get_cursor(0)
    local line, column = pos[1] - 1, pos[2] + 1

    local buf = vim.api.nvim_get_current_buf()
    local line_text = vim.api.nvim_buf_get_lines(buf, line, line + 1, false)[1]

    local start_col, end_col = column, column

    local pattern = "[%w_-]"
    if cWORD then pattern = "[%S]" end

    -- Expand left until `pattern` doesn't match
    while start_col > 0 and line_text:sub(start_col, start_col):match(pattern) do
        start_col = start_col - 1
    end

    if not line_text:sub(start_col, start_col):match(pattern) then
        start_col = start_col + 1
    end

    -- Expand right until `pattern` doesn't match
    while end_col < #line_text and line_text:sub(end_col, end_col):match(pattern) do
        end_col = end_col + 1
    end

    if not line_text:sub(end_col, end_col):match(pattern) then
        end_col = end_col - 1
    end

    return {
        text_to_replace = { line_text:sub(start_col, end_col) },
        line = line,
        start_col = start_col,
        end_col = end_col,
    }
end

---@param text_to_replace string[]
---@param position Position
---@return string[]
local function handle_visual(text_to_replace, position)
    if #text_to_replace > 1 then
        text_to_replace[1] = text_to_replace[1]:sub(position.start_col)
        text_to_replace[#text_to_replace] = text_to_replace[#text_to_replace]:sub(1, position.end_col)
    elseif #text_to_replace == 1 then
        text_to_replace[1] = text_to_replace[1]:sub(position.start_col, position.end_col)
    end

    return text_to_replace
end

---@param buf number
---@param replacement string[]
---@param position Position
local function handle_visual_line(buf, replacement, position)
    vim.api.nvim_buf_set_lines(buf, position.start_row - 1, position.end_row, false, replacement)
end

-- TODO: handle lsp rename when coercing. The following link
-- could be an inspiration since it seems to handle it by default.
-- https://github.com/gregorias/coerce.nvim
---@param to function
---@param position Position
---@param mode string
---@param is_cWORD boolean
M.handle_coerce = function(to, position, mode, is_cWORD)
    local buf = vim.api.nvim_get_current_buf()
    if mode == "" then
        local cword = M.get_cword_position(is_cWORD)
        set_text(buf, position, { to(cword.text_to_replace[1]) })
        return
    end

    if mode == "\22" then
        print("Visual block mode is not supported")
        return
    end

    local to_replace = vim.api.nvim_buf_get_lines(buf, position.start_row - 1, position.end_row, false)

    if mode == "v" then
        to_replace = handle_visual(to_replace, position)
    end

    local replaced = {}
    for _, text in pairs(to_replace) do
        table.insert(replaced, to(text))
    end

    if mode == "V" then
        handle_visual_line(buf, replaced, position)
        return
    end

    set_text(buf, position, replaced)
end

return M

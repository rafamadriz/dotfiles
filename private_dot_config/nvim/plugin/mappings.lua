local map = vim.keymap.set

-- Move by visible lines, fixes annoying behavior on wrapped lines
map({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true })
map({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true })

-- Kinda of smooth scrolling, help scroll-smooth
map("n", "<C-U>", "<C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y>")
map("n", "<C-D>", "<C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E>")

-- Easier builtin completion
map("i", "<c-space>", "<C-X><C-O>")
map("i", "<C-F>", "<C-X><C-F>")
map("i", "<C-L>", "<C-X><C-L>")

-- Terminal
map("t", [[<C-\>]], [[<C-\><C-n>]])

-- Disable repeat last recorded character
map("n", "Q", "<Nop>")
-- I always type :Q by mistake
vim.api.nvim_create_user_command("Q", function(arg)
    if arg.bang then
        vim.cmd.quit { bang = true }
    else
        vim.cmd.quit()
    end
end, { bang = true })

-- I always type :W
vim.api.nvim_create_user_command("W", function(arg)
    if arg.bang then
        vim.cmd.write { bang = true }
    else
        vim.cmd.update()
    end
end, { bang = true })

-- Center buffer when searching
--map("n", "n", "nzzzv")
--map("n", "N", "Nzzzv")

-- `^` to go to beginning of line with a character is not convenient, never use `H` in normal mode,
-- so why not use it for that? Might as well add `L` for end of line to keep it consistent
map({ "n", "v" }, "H", "^")
map({ "n", "v" }, "L", "g_")

-- Keep cursor position when joining lines
map("n", "J", "mzJ`z", { desc = "Join lines" })

-- Make sure to go to proper indentation level when pressing i
-- source: https://www.reddit.com/r/neovim/comments/12rqyl8/5_smart_minisnippets_for_making_text_editing_more/
map("n", "i", function()
    if #vim.fn.getline "." == 0 then
        return [["_cc]]
    else
        return "i"
    end
end, { expr = true })

-- Jump between last two buffers
map("n", "<BS>", "<C-^>", { desc = "Jump between last two buffers" })

-- Fix annoying behavior where for example: If in blockwise visual mode
-- and add some text through multiple lines, I would end with <C-c>
-- (out of muscle memory), but this cancels whatever I did and have to do it again
-- source: https://github.com/neovim/neovim/issues/16416
map("i", "<C-c>", "<C-c>")

-- Move selected block of text up/down
map("v", "K", ":move '<-2<CR>gv=gv", { desc = "Move selected block of text up" })
map("v", "J", ":move '>+1<CR>gv=gv", { desc = "Move selected block of text down" })

-- Copy/paste with system clipboard
map({ "n", "x", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+y$]], { desc = "Yank to system clipboard (end of line)" })
map("n", "<leader>p", [["+p`[v`]=]], { desc = "Paste from system clipboard" })
map("n", "<leader>P", [["+P]], { desc = "Paste from system clipboard" })
-- Paste in Visual with `P` to not copy selected text (`:h v_P`)
map("x", "<leader>p", [["+P]], { desc = "Paste from system clipboard" })

-- Reselect latest changed, put, or yanked text
map("n", "gV", [["`[" . strpart(getregtype(), 0, 1) . "`]"]], { expr = true, desc = "Visually select changed text" })

-- Search inside visually highlighted text. Use `silent = false` for it to
-- make effect immediately.
map("x", "/", "<esc>/\\%V", { silent = false, desc = "Search inside visual selection" })

-- Search visually selected text (slightly better than builtins in Neovim>=0.8)
map("x", "*", [[y/\V<C-R>=escape(@", '/\')<CR><CR>]])
map("x", "#", [[y?\V<C-R>=escape(@", '?\')<CR><CR>]])

-- Correct latest misspelled word by taking first suggestion.
-- Use `<C-g>u` in Insert mode to mark this as separate undoable action.
-- Source: https://stackoverflow.com/a/16481737
-- NOTE: this remaps `<C-z>` in Normal mode (completely stops Neovim), but
-- it seems to be too harmful anyway.
map("n", "<C-Z>", "[s1z=", { desc = "Correct latest misspelled word" })
map("i", "<C-Z>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { desc = "Correct latest misspelled word" })

-- Some useful mappings when doing stuff in visual mode
map("v", "y", "y`]", { desc = "Keep cursor position when yanking text" })
map("v", "<", "<gv", { desc = "Keep visual selection when indenting to left" })
map("v", ">", ">gv", { desc = "Keep visual selection when indenting to right" })

-- Move sideways in command mode. Using `silent = false` makes movements
-- to be immediately shown.
map("c", "<C-h>", "<Left>", { silent = false, desc = "Left" })
map("c", "<C-l>", "<Right>", { silent = false, desc = "Right" })

-- Move to start/end on line in command mode
map("c", "<C-a>", "<home>", { desc = "Move to end of line" })
map("c", "<C-e>", "<end>", { desc = "Move to begining of line" })

map("n", "<leader>;", "mmA;<ESC>`m", { desc = "Apend semicolon" })
map("n", "<leader>,", "mmA,<ESC>`m", { desc = "Apend comma" })

-- Save and delete buffers
map("n", "<leader>w", ":update<CR>", { desc = "Write buffer" })
map("v", "<leader>w", "<ESC>:update<CR>gv", { desc = "Write buffer" })
map("n", "<leader>q", ":bdelete<CR>", { desc = "Quit buffer" })
map("n", "<leader>Q", ":write | silent %bd | silent e# | bd#<CR>", { desc = "Quit all buffers but current" })
map("n", "<leader>!", ":noautocmd write<CR>", { desc = "Save noautocmd" })

-- Resize windows
-- expand or minimize current buffer in "actual" direction
-- this is useful as mapping ":resize 2" stand-alone might otherwise not be in
-- the right direction if mapped to ctrl-left arrow or something related use
local resize = function(vertical, margin)
    local cmd = vim.cmd
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

    local symbol = sign and "+" or "-"
    local dir = vertical and "vertical " or ""
    local _cmd = dir .. "resize " .. symbol .. math.abs(margin) .. "<CR>"
    cmd(_cmd)
end

map({ "n", "t" }, "<C-Up>", function() resize(false, -2) end, { desc = "Resize up window horizontally" })
map({ "n", "t" }, "<C-Down>", function() resize(false, 2) end, { desc = "Resize down window horizontally" })
map({ "n", "t" }, "<C-Left>", function() resize(true, -2) end, { desc = "Resize left window vertically" })
map({ "n", "t" }, "<C-Right>", function() resize(true, 2) end, { desc = "Resize right window vertically" })

-- Copy text to clipboard using codeblock format ```{ft}{content}```
-- Source: https://www.reddit.com/r/neovim/comments/1dfvluw/share_your_favorite_settingsfeaturesexcerpts_from/
vim.api.nvim_create_user_command("CopyCodeBlock", function(opts)
    local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, true)
    local content = table.concat(lines, "\n")
    local result = string.format("```%s\n%s\n```", vim.bo.filetype, content)
    vim.fn.setreg("+", result)
    -- vim.notify 'Text copied to clipboard'
end, { range = true })

-- jump to next/prev file
local navigate_files = function(direction)
    local current_file = vim.fn.expand "%:p"
    local current_dir = vim.fn.expand "%:p:h"

    -- get all files in the directory, sorted
    local files = vim.fn.glob(current_dir .. "/*", false, true)
    files = vim.tbl_filter(function(file) return vim.fn.isdirectory(file) == 0 end, files)
    table.sort(files)

    if #files == 0 then
        -- no files in directory
        return
    end

    local target_index

    if direction == "first" then
        target_index = 1
    elseif direction == "last" then
        target_index = #files
    else
        local index = vim.fn.index(files, current_file) + 1
        if index <= 0 then
            return
        end

        if direction == "next" then
            target_index = index + 1
            if target_index > #files then
                return
            end
        elseif direction == "prev" then
            target_index = index - 1
            if target_index < 1 then
                return
            end
        else
            -- Invalid direction
            return
        end
    end

    vim.cmd("e " .. files[target_index])
end

map("n", "[f", function() navigate_files "prev" end, { desc = "Previous file in directory" })
map("n", "]f", function() navigate_files "next" end, { desc = "Next file in directory" })
map("n", "[F", function() navigate_files "first" end, { desc = "First file in directory" })
map("n", "]F", function() navigate_files "last" end, { desc = "Last file in directory" })

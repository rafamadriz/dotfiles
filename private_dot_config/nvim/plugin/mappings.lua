local map = vim.keymap.set

-- Move by visible lines, fixes annoying behavior on wrapped lines
map({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true })
map({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true })

-- Kinda of smooth scrolling, help scroll-smooth
map("n", "<C-U>", "<C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y>")
map("n", "<C-D>", "<C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E>")

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

-- Center buffer when searching
--map("n", "n", "nzzzv")
--map("n", "N", "Nzzzv")

-- `^` to go to beginning of line with a character is not convenient, never use `H` in normal mode,
-- so why not use it for that? might as well add `L` for end of line to keep it consistent
map({ "n", "v" }, "H", "^")
map({ "n", "v" }, "L", "g_")

-- Keep cursor position when joinng lines
map("n", "J", "mzJ`z", { desc = "Join lines" })

-- Make sure to go to proper indentantion level when pressing i
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

-- Pair bracket
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })
map("n", "]B", "<cmd>blast<cr>", { desc = "Last buffer " })
map("n", "[B", "<cmd>bfirst<cr>", { desc = "First buffer " })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix " })
map("n", "[q", "<cmd>cprevious<cr>", { desc = "Previous quickfix " })
map("n", "]Q", "<cmd>clast<cr>", { desc = "Last quickfix " })
map("n", "[Q", "<cmd>cfirst<cr>", { desc = "First quickfix" })
map("n", "]l", "<cmd>lnext<cr>", { desc = "Next locationlist" })
map("n", "[l", "<cmd>lprevious<cr>", { desc = "Previous locationlist " })
map("n", "]L", "<cmd>llast<cr>", { desc = "Last locationlist " })
map("n", "[L", "<cmd>lfirst<cr>", { desc = "First locationlist " })

-- Fix annoying behavior where for example: If in blockwise visual mode
-- and add some text through multiple lines, I would end with <C-c>
-- (out of muscle memory), but this cancels whatever I did and have to do it again
-- source: https://github.com/neovim/neovim/issues/16416
map("i", "<C-c>", "<C-c>")

-- Add empty lines before and after cursor line
map("n", "gO", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", { desc = "Put empty line above" })
map("n", "go", "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>", { desc = "Put empty line below" })

-- Move selected block of text up/down
map("v", "K", ":move '<-2<CR>gv=gv", { desc = "Move selected block of text up" })
map("v", "J", ":move '>+1<CR>gv=gv", { desc = "Move selected block of text down" })

-- Copy/paste with system clipboard
map({ "n", "x" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
map("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
-- - Paste in Visual with `P` to not copy selected text (`:h v_P`)
map("x", "<leader>p", '"+P', { desc = "Paste from system clipboard" })

-- Reselect latest changed, put, or yanked text
map("n", "gV", '"`[" . strpart(getregtype(), 0, 1) . "`]"', { expr = true, desc = "Visually select changed text" })

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

-- Buffers
map("n", "<leader>bs", ":update<CR>", { desc = "Save buffer" })
map("v", "<leader>bs", "<ESC>:update<CR>gv", { desc = "Save buffer" })
map("n", "<leader>bq", ":bdelete<CR>", { desc = "Quit buffer" })
map("n", "<leader>bQ", ":write | silent %bd | silent e# | bd#<CR>", { desc = "Quit all buffers but current" })
map("n", "<leader>b!", ":noautocmd write<CR>", { desc = "Save noautocmd" })

-- Resize windows
-- expand or minimize current buffer in "actual" direction
-- this is useful as mapping ":resize 2" stand-alone might otherwise not be in
-- the right direction if mapped to ctrl-leftarrow or something related use
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
